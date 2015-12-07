class Owner
  attr_reader :mkey

  def self.all
    Contact.uniq.pluck(:owner_mkey).map { |owner_mkey| new owner_mkey }
  end

  def self.subscribed
    all.select { |owner| !owner.unsubscribed? }
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

  def notifications
    Notification.by_owner_mkey mkey
  end

  def unsubscribed?
    !Notification.unsubscribed_by_contacts(contacts).empty?
  end
end
