module ContactsBuilders
  def create_contact(owner_mkey, total_score, client_mobile, additions = {})
    contact = create(:contact, owner_mkey: owner_mkey, total_score: total_score, additions: additions)
    create(:vector_mobile, contact: contact, value: client_mobile)
    contact
  end
end

RSpec.configure do |config|
  config.include(ContactsBuilders)
end
