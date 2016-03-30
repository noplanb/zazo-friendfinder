class Contact::ControllerManager::Base
  attr_reader :owner_mkey, :raw_params, :validation

  class << self
    def params_validation(params = nil)
      @params_validation ||= params
    end
  end

  def initialize(owner_mkey, raw_params)
    @owner_mkey = owner_mkey
    @raw_params = raw_params
    @validation = RawParamsValidation.new(raw_params, self.class.params_validation)
  end

  def do
    validation.valid? && wrap_transaction { do_safe }
  end

  def log_messages(status)
    if status == :success
      WriteLog.info(self, "success; owner_mkey: '#{owner_mkey}'; params: #{raw_params.inspect}")
    else
      WriteLog.info(self, "failure; owner_mkey: '#{owner_mkey}'; errors: #{errors.inspect}; params: #{raw_params.inspect}")
    end
  end

  def errors
    validation.errors.messages
  end

  private

  def wrap_transaction
    ActiveRecord::Base.transaction { yield; return true }
    false
  end

  class RawParamsValidation
    include ActiveModel::Validations

    attr_reader :raw_params, :params_validation

    validates :raw_params, presence: true
    validate  :raw_params_with_correct_structure

    def initialize(raw_params, params_validation)
      @raw_params = raw_params
      @params_validation = params_validation
    end

    def raw_params_with_correct_structure
      if raw_params.kind_of?(Hash)
        params_validation && params_validation.each do |param, desc|
          unless raw_params[param.to_s].kind_of?(desc[:type])
            errors.add(:raw_params, "raw_params['#{param}'] must be type of #{desc[:type]}")
          end
        end
      else
        errors.add(:raw_params, 'raw_params must be type of Hash')
      end
    end
  end
end
