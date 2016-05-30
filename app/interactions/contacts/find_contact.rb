class Contacts::FindContact < ActiveInteraction::Base
  integer :id
  object :owner

  def execute
    contact = Contact.find_by_id(id)
    validate_contact_presence(contact) && validate_contact_ownership(contact)
    contact
  end

  private

  def validate_contact_presence(contact)
    if contact
      true
    else
      errors.add(:id, "contact not found by id=#{id}")
      false
    end
  end

  def validate_contact_ownership(contact)
    if contact.owner_mkey == owner.mkey
      true
    else
      errors.add(:id, "current user is not owner of contact with id=#{id}")
      false
    end
  end
end
