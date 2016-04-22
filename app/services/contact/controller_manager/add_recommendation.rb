class Contact::ControllerManager::AddRecommendation < Contact::ControllerManager::BaseHandler
  params_validation to_mkeys: { type: Array },
                    contact_mkey: { type: String }

  def do_safe
    raw_params['to_mkeys'].each { |mkey| add_recommendation_to_owner(mkey) }
  end

  private

  def add_recommendation_to_owner(mkey)
    contact = Owner.new(mkey).contacts.where(zazo_mkey: raw_params['contact_mkey']).try(:first)
    contact ? update_contact_with_recommendation(contact) : create_contact_with_recommendation(mkey)
  end

  def update_contact_with_recommendation(contact)
    contact.additions ||= {}
    contact.additions['recommended_by'].tap do |recommended_by|
      recommended_by ||= []
      recommended_by << owner_mkey
      recommended_by.uniq!
    end
    contact.save
  end

  def create_contact_with_recommendation(mkey)
    contact = Contact.new(owner_mkey: mkey, zazo_mkey: raw_params['contact_mkey'], additions: { recommended_by: [owner_mkey] })
    contact.save.tap { |status| status ? Resque.enqueue(ResqueWorker::UpdateMkeyDefinedContact, contact.id) : fail(ActiveRecord::Rollback) }
  end
end
