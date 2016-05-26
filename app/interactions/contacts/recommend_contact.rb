class Contacts::RecommendContact < ActiveInteraction::Base
  object :owner
  hash :recommendations do
    string :contact_mkey
    array :to_mkeys do
      string
    end
  end

  def execute
    recommendations[:to_mkeys].each { |mkey| add_recommendation_to_owner(mkey) }
  end

  private

  def add_recommendation_to_owner(mkey)
    contact = Owner.new(mkey).contacts.where(zazo_mkey: recommendations[:contact_mkey]).try(:first)
    contact ? update_contact_with_recommendation(contact) : create_contact_with_recommendation(mkey)
  end

  def update_contact_with_recommendation(contact)
    contact.additions ||= {}
    recommended_by = contact.additions['recommended_by'] || []
    recommended_by << owner.mkey
    contact.update_attributes(
      additions: contact.additions.merge(recommended_by: recommended_by.uniq))
  end

  def create_contact_with_recommendation(mkey)
    contact = Contact.new(owner_mkey: mkey, zazo_mkey: recommendations[:contact_mkey], additions: { recommended_by: [owner.mkey] })
    contact.save && Resque.enqueue(ResqueWorker::UpdateMkeyDefinedContact, contact.id)
  end
end
