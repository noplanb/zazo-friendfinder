FactoryGirl.define do
  factory :vector do
    name      'mobile'
    value     { Faker::PhoneNumber.cell_phone }
    association :connection

    #
    # types
    #

    trait :email do
      name  'email'
      value { Faker::Internet.email }
    end

    trait :facebook do
      name  'facebook'
      value { Faker::Internet.email }
    end

    #
    # additions
    #

    trait :messages_sent do
      additions do
        { messages_sent: Faker::Number.number(2).to_i }
      end
    end

    trait :marked_as_favorite do
      additions do
        { marked_as_favorite: true }
      end
    end

    #
    # factories
    #

    factory :vector_mobile, traits: []
    factory :vector_mobile_messages, traits: [:messages_sent]
    factory :vector_mobile_favorite, traits: [:marked_as_favorite]
    factory :vector_mobile_messages_favorite, traits: [:messages_sent, :marked_as_favorite]

    factory :vector_email, traits: [:email]
    factory :vector_email_favorite, traits: [:email, :marked_as_favorite]

    factory :vector_facebook, traits: [:facebook]
  end
end
