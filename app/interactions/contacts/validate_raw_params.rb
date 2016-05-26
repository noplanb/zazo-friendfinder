class Contacts::ValidateRawParams < ActiveInteraction::Base
  array :contacts

  def execute
    invalid_contacts = contacts.select do |contact|
      !contact['vectors'] || !contact['display_name'] ||
        contact['vectors'].empty? || contact['display_name'].empty?
    end
    errors.add(:invalid_contacts, invalid_contacts) unless invalid_contacts.empty?
  end
end
