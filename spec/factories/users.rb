FactoryGirl.define do
  factory :user do
    mkey { SecureRandom.hex }
    auth { SecureRandom.hex }
  end
end
