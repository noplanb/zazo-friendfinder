class Owner
  attr_reader :mkey

  def self.subscribed
    Contact.uniq.pluck(:owner_mkey).map do |owner_mkey|
      new owner_mkey
    end.select { |owner| !owner.unsubscribed? }
  end

  def initialize(mkey)
    @mkey = mkey
  end

  def contacts
    Contact.by_owner mkey
  end

  def not_proposed_contacts
    contacts.select { |contact| !contact.notified? }
  end

  def unsubscribed?
    !Notification.unsubscribed_by_contacts(contacts).empty?
  end
end
