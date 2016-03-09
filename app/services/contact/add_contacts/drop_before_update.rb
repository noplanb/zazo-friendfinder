class Contact::AddContacts::DropBeforeUpdate
  attr_reader :owner

  def initialize(owner)
    @owner = Owner.new(owner)
  end

  def do
    # todo: speed up this
    owner.contacts.select do |c|
      !(c.additions_value('recommended_by') || c.additions_value('rejected_by_owner'))
    end.each(&:destroy)
  end
end
