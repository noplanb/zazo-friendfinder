FactoryGirl.define do
  factory :contact do
    owner_mkey   { SecureRandom.hex }
    first_name   { Faker::Name.first_name }
    last_name    { Faker::Name.last_name }
    expires_at   { Time.now + 2.weeks }
    display_name { "#{first_name} #{last_name}" }
    total_score  0
  end
end
