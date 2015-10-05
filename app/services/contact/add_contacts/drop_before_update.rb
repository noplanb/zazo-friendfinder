class Contact::AddContacts::DropBeforeUpdate
  attr_reader :owner

  def initialize(owner)
    @owner = owner
  end

  def do
    Contact.by_owner(owner).select { |c| !(c.additions_value('recommended_by') || c.additions_value('rejected_by_owner')) }.each &:destroy
  end
end
