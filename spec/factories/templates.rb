FactoryGirl.define do
  factory :template do
    content  'Hello!'
    category 'user_joined'
    kind     'mobile'
  end
end
