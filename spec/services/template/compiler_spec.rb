require 'rails_helper'

RSpec.describe Template::Compiler do
  let(:template) { FactoryGirl.build :template, content: '<%= contact.name %> joined Zazo!' }
  let(:compiler) { described_class.new template }

  describe '#preview' do
    subject { compiler.preview }

    it { is_expected.to eq 'Syd Barrett joined Zazo!' }
  end

  describe '#compile' do
    let(:notification) { FactoryGirl.build :notification }
    let(:template_data) { TemplateData.new notification }

    before { compiler.compile template_data }
    it { expect(compiler.content).to eq "#{notification.contact.display_name} joined Zazo!" }
  end
end
