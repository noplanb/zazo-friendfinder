# TODO: write some specs

class Contact::DropContacts
  attr_reader :owner_mkey, :owner

  def initialize(owner_mkey)
    @owner_mkey = owner_mkey
    @owner = Owner.new(owner_mkey)
  end

  def do
    WriteLog.info(self, "contacts deleting was started for owner=#{owner_mkey}")
    owner.contacts.not_proposed.select do |c|
      !(c.additions_value('recommended_by') || c.additions_value('rejected_by_owner'))
    end.each(&:destroy)
  end
end
