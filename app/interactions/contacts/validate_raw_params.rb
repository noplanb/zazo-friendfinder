class Contacts::ValidateRawParams < ActiveInteraction::Base
  array :contacts

  def execute
    invalid_contacts = contacts.select do |contact|
      !contact['vectors'] || !contact['display_name'] ||
        contact['vectors'].empty? || contact['display_name'].empty?
    end
    unless invalid_contacts.empty?
      invalid_contacts.each { |contact| errors.add(:invalid_contacts, contact)  }
    end
  end
end
