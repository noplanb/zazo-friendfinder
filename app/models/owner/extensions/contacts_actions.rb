module Owner::Extensions::ContactsActions
  class Actions
    attr_reader :owner

    def initialize(owner)
      @owner = owner
    end

    def find_contact_and_update_zazo_info
      owner.contacts.map do |contact|
        Contact::Update::FindZazoContact.new(contact).do
        Contact::Update::UpdateZazoInfo.new(contact).do
      end
    end
  end

  def contacts_actions
    @contacts_actions ||= Actions.new(self)
  end
end
