require 'rails_helper'

RSpec.describe Notification::Create do
  let(:instance) { described_class.new category, contact }

  describe '#do' do
    let(:category) { 'user_joined' }
    let(:contact) { FactoryGirl.create :contact }
    let(:contact_name) { "#{contact.first_name} #{contact.last_name}" }
    let!(:template_email) do
      FactoryGirl.create :template, kind: 'email',
                         content: '<%= contact.name %> joined Zazo!'
    end

    subject do
      instance.do.map do |n|
        { compiled_content: n.compiled_content, template_id: n.template_id }
      end
    end

    context 'with all templates' do
      let!(:template_mobile_notification) do
        FactoryGirl.create :template, kind: 'mobile_notification',
                           content: '<%= contact.name %> joined Zazo!'
      end

      it do
        expected = [
          { compiled_content: "#{contact_name} joined Zazo!", template_id: template_email.id },
          { compiled_content: "#{contact_name} joined Zazo!", template_id: template_mobile_notification.id }
        ]
        is_expected.to eq expected
      end
      it { expect(subject.size).to eq 2 }
    end

    context 'with one templates' do
      it do
        expected = [
          { compiled_content: "#{contact_name} joined Zazo!", template_id: template_email.id },
        ]
        is_expected.to eq expected
      end
      it { expect(subject.size).to eq 1 }
    end
  end
end
