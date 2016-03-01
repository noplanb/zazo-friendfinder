require 'rails_helper'

RSpec.describe Notification::Create do
  let(:instance) { described_class.new category, contact }

  describe '#do' do
    let(:category) { 'user_joined' }
    let(:content) { '<%= contact.name %> joined Zazo!' }
    let(:contact) { FactoryGirl.create :contact }
    let(:contact_name) { "#{contact.first_name} #{contact.last_name}" }

    subject do
      instance.do.map { |n| { kind: n.kind, category: n.category, compiled_content: n.compiled_content } }
    end

    before do
      render_attrs = { inline: '<%= @data.contact.name %> joined Zazo!' }
      allow_any_instance_of(Template::Render).to receive(:render_attrs).and_return render_attrs
    end

    it do
      expected = [
        { kind: 'email',  category: 'user_joined', compiled_content: "#{contact_name} joined Zazo!" },
        { kind: 'mobile', category: 'user_joined', compiled_content: "#{contact_name} joined Zazo!" }
      ]
      is_expected.to eq expected
    end
    it { expect(subject.size).to eq 2 }
  end
end
