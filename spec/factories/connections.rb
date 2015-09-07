FactoryGirl.define do
  factory :connection do
    owner      { SecureRandom.hex }
    first_name { Faker::Name.first_name }
    last_name  { Faker::Name.last_name }
    expires_at { Time.now + 2.weeks }

    trait :simple_vectors do
      after :create do |conn|
        conn.vectors << FactoryGirl.create(:vector_mobile_messages)
        conn.vectors << FactoryGirl.create(:vector_mobile_favorite)
        conn.vectors << FactoryGirl.create(:vector_mobile_messages_favorite)
        conn.vectors << FactoryGirl.create(:vector_email)
        conn.vectors << FactoryGirl.create(:vector_email_favorite)
        conn.vectors << FactoryGirl.create(:vector_facebook)
        conn.save!
      end
    end

    trait :hardcoded_vectors do
      after :create do |conn|
        conn.vectors << [
          FactoryGirl.create(:vector_mobile, additions: { messages_sent: 54 }),
          FactoryGirl.create(:vector_mobile, additions: { messages_sent: 27, marked_as_favorite: true }),
          FactoryGirl.create(:vector_mobile),
          FactoryGirl.create(:vector_mobile),
          FactoryGirl.create(:vector_email, additions: { marked_as_favorite: true }),
          FactoryGirl.create(:vector_email, additions: { messages_sent: 12 }),
          FactoryGirl.create(:vector_email),
          FactoryGirl.create(:vector_email)
        ]
        conn.save!
      end
    end

    factory :connection_with_simple_vectors, traits: [:simple_vectors]
    factory :hardcoded_vectors, traits: [:hardcoded_vectors]
  end
end
