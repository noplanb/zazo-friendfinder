class Admin::Owners::ClearContactsStatuses < Admin::Owners
  def do
    @owner.contacts.each do |contact|
      new_additions = contact.additions.except('added_by_owner', 'ignored_by_owner')
      contact.update_attributes(additions: new_additions)
    end
    [true, 'Statuses was cleared for all contacts']
  end
end
