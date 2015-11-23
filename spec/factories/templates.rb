FactoryGirl.define do
  factory :template do
    content  '<%= contact.name %> joined Zazo!'
    category 'user_joined'
    kind     'mobile'

    factory(:template_email)  { kind 'email' }
    factory(:template_mobile) { kind 'mobile' }
  end
end
