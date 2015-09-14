class Contact::AddRecommendation
  attr_reader :current_user, :raw_params

  # todo: add validations

  def initialize(current_user, params)
    @current_user = current_user
    @raw_params   = params
  end

  def do
    wrap_transaction do
      raw_params['to_mkeys'].each { |mkey| add_recommendation_to_owner mkey }
    end
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
    contact.save || fail(ActiveRecord::Rollback)
  end
end
