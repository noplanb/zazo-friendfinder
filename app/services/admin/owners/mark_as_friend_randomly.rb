class Admin::Owners::MarkAsFriendRandomly < Admin::Owners
  def do
    @owner.contacts.each do |contact|
      new_additions = (contact.additions || {}).merge('marked_as_friend' => [true, false].sample)
      contact.update_attributes(additions: new_additions)
    end
    [true, 'All contacts was marked as friend randomly']
  end
end
