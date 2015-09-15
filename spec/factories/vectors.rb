FactoryGirl.define do
  factory :vector do
    name      'mobile'
    value     { Faker::PhoneNumber.cell_phone }
    association :contact

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

    trait :sms_messages_sent do
      additions do
        { sms_messages_sent: Faker::Number.number(2).to_i }
      end
    end

    trait :email_messages_sent do
      additions do
        { email_messages_sent: Faker::Number.number(2).to_i }
      end
    end

    #
    # factories
    #

    factory :vector_mobile, traits: []
    factory :vector_mobile_sms_messages_sent, traits: [:sms_messages_sent]

    factory :vector_email, traits: [:email]
    factory :vector_email_email_messages_sent, traits: [:email, :email_messages_sent]

    factory :vector_facebook, traits: [:facebook]
  end
end
