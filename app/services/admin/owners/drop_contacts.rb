class Admin::Owners::DropContacts < Admin::Owners
  def do
    @owner.contacts.destroy_all
    [true, 'All contacts was destroyed']
  end
end
