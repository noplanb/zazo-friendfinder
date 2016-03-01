if Rails.env.test? && ENV['dev'] == 'true'
  owner = SecureRandom.hex

  contact_1 = FactoryGirl.create :contact, owner_mkey: owner
  contact_2 = FactoryGirl.create :contact, owner_mkey: owner
  contact_3 = FactoryGirl.create :contact, owner_mkey: owner
  contact_4 = FactoryGirl.create :contact, owner_mkey: owner

  vector_1_1 = FactoryGirl.create :vector_mobile_sms_messages_sent, contact: contact_1
  vector_1_2 = FactoryGirl.create :vector_email,  contact: contact_1
  vector_2_1 = FactoryGirl.create :vector_mobile, contact: contact_2
  vector_2_2 = FactoryGirl.create :vector_mobile, contact: contact_2
  vector_3_1 = FactoryGirl.create :vector_email,  contact: contact_3

  FactoryGirl.create :notification_email,  contact: contact_1
  FactoryGirl.create :notification_mobile, contact: contact_1
  FactoryGirl.create :notification_mobile, contact: contact_2
end
