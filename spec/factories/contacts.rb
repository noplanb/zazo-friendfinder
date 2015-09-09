FactoryGirl.define do
  factory :contact do
    owner      { SecureRandom.hex }
    first_name { Faker::Name.first_name }
    last_name  { Faker::Name.last_name }
    expires_at { Time.now + 2.weeks }
  end
end
