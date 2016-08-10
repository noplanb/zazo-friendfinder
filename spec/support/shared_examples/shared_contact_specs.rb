RSpec.shared_examples 'contact is added specs' do
  it { expect(contact.added?).to be true }
  it { expect(contact.ignored?).to be false }
  it { expect(contact.additions).to eq 'added_by_owner' => true }
end

RSpec.shared_examples 'contact is ignored specs' do
  it { expect(contact.added?).to be false }
  it { expect(contact.ignored?).to be true }
  it { expect(contact.additions).to eq 'ignored_by_owner' => true }
end
