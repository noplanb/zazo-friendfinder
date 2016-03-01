FactoryGirl.define do
  factory :notification do
    contact
    kind     'email'
    category 'user_joined'
    nkey     { SecureRandom.hex }

    factory(:notification_email)  { kind 'email' }
    factory(:notification_mobile) { kind 'mobile' }
  end
end
