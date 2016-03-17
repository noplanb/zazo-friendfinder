FactoryGirl.define do
  factory :contact do
    owner_mkey   { SecureRandom.hex }
    first_name   { Faker::Name.first_name }
    last_name    { Faker::Name.last_name }
    expires_at   { Time.now + 2.weeks }
    display_name { "#{first_name} #{last_name}" }
    total_score  0

    #
    # additions
    #

    trait :marked_as_friend do
      additions do
        { marked_as_friend: true }
      end
    end

    trait :marked_as_not_friend do
      additions do
        { marked_as_friend: false }
      end
    end

    #
    # factories
    #

    factory :contact_as_friend, traits: [:marked_as_friend]
    factory :contact_as_not_friend, traits: [:marked_as_not_friend]
  end
end
