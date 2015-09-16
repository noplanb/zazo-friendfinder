class Contact::AddRecommendation
  attr_reader :current_user, :raw_params, :validation

  def initialize(current_user, params)
    @current_user = current_user
    @raw_params   = params
    @validation   = RawParamsValidation.new raw_params
  end

  def do
    validation.valid? && wrap_transaction do
      raw_params['to_mkeys'].each { |mkey| add_recommendation_to_owner mkey }
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

  def add_recommendation_to_owner(mkey)
    contact = Contact.by_owner(mkey).where(zazo_mkey: raw_params['contact_mkey']).try :first
    contact ? update_contact_with_recommendation(contact) : create_contact_with_recommendation(mkey)
  end

  def update_contact_with_recommendation(contact)
    contact.additions ||= {}
    contact.additions['recommended_by'].tap do |recommended_by|
      recommended_by ||= []
      recommended_by << current_user.mkey
      recommended_by.uniq!
    end
    contact.save
  end

  def create_contact_with_recommendation(owner)
    # todo: set zazo_id and name for contact in new thread - Contact::SetZazoIdAndName
    contact = Contact.new owner: owner, zazo_mkey: raw_params['contact_mkey'], additions: { recommended_by: [current_user.mkey] }
    contact.save ? Score::CalculationByContact.new(contact).do_async : fail(ActiveRecord::Rollback)
  end

  #
  # validations
  #

  class RawParamsValidation
    include ActiveModel::Validations

    attr_reader :raw_params

    validates :raw_params, presence: true
    validate :raw_params_with_correct_structure

    def initialize(raw_params)
      @raw_params = raw_params
    end

    def raw_params_with_correct_structure
      if raw_params.kind_of? Hash
        errors.add(:raw_params, 'raw_params[\'to_mkeys\'] must be type of Array') unless raw_params['to_mkeys'].kind_of? Array
        errors.add(:raw_params, 'raw_params[\'contact_mkey\'] must be present') if raw_params['contact_mkey'].nil?
      else
        errors.add(:raw_params, 'raw_params must be type of Hash')
      end
    end
  end
end
