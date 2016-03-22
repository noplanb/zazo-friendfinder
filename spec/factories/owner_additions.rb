FactoryGirl.define do
  factory :owner_additions, class: Owner::Additions do
    mkey { SecureRandom.hex }
    unsubscribed false
  end
end
