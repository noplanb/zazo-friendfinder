# controller manager service

class Contact::RejectSuggestion
  attr_reader :current_user_mkey, :raw_params, :validation

  def initialize(current_user_mkey, raw_params)
    @current_user_mkey = current_user_mkey
    @raw_params = raw_params
    @validation = RawParamsValidation.new raw_params
  end

  def do
    validation.valid? && wrap_transaction do
      raw_params['rejected'].each do |id|
        contact = Contact.find_by_id(id)
        unless contact
          add_error(:raw_params_id, "contact with id=#{id} is not exist")
          fail(ActiveRecord::Rollback)
        end
        reject_contact(contact)
      end
    end
  end

  def errors
    validation.errors.messages.merge(@errors || {})
  end

  def log_messages(status)
    if status == :success
      WriteLog.info(self, "success; current_user: '#{current_user_mkey}'; params: #{raw_params.inspect}")
    else
      WriteLog.info(self, "failure; current_user: '#{current_user_mkey}'; errors: #{errors.inspect}; params: #{raw_params.inspect}")
    end
  end

  private

  def wrap_transaction
    ActiveRecord::Base.transaction { yield; return true }
    false
  end

  def reject_contact(contact)
    contact.additions ||= {}
    contact.additions['rejected_by_owner'] = true
    contact.save
  end

  #
  # validations
  #

  def add_error(key, error)
    @errors ||= {}
    @errors[key] ||= []
    @errors[key] << error
  end

  class RawParamsValidation
    include ActiveModel::Validations

    attr_reader :raw_params

    validates :raw_params, presence: true
    validate  :raw_params_with_correct_structure

    def initialize(raw_params)
      @raw_params = raw_params
    end

    def raw_params_with_correct_structure
      if raw_params.kind_of? Hash
        errors.add(:raw_params, 'raw_params[\'rejected\'] must be type of Array') unless raw_params['rejected'].kind_of? Array
      else
        errors.add(:raw_params, 'raw_params must be type of Hash')
      end
    end
  end
end
