class Contact::DropContacts
  attr_reader :current_user_mkey, :owner

  def initialize(current_user_mkey)
    @current_user_mkey = current_user_mkey
    @owner = Owner.new(current_user_mkey)
  end

  def do
    WriteLog.info(self, "contacts deleting was started for current_user=#{current_user_mkey}")
    owner.contacts.select do |c|
      !(c.additions_value('recommended_by') || c.additions_value('rejected_by_owner'))
    end.each(&:destroy)
  end
end
