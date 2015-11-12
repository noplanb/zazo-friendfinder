FactoryGirl.define do
  factory :notification do
    contact
    category 'user_joined'
    nkey     { SecureRandom.hex }
  end
end
