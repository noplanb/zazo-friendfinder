FactoryGirl.define do
  factory :template do
    content  '<%= contact.name %> joined Zazo!'
    category 'user_joined'
    kind     'mobile'
  end
end
