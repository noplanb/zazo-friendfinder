class Owner
  attr_reader :mkey

  def initialize(mkey)
    @mkey = mkey
  end

  def contacts
    Contact.by_owner mkey
  end

  def not_proposed_contacts
    contacts.select { |contact| !Notification.match_by_contact?(contact) }
  end

  def unsubscribed?
    !Notification.where(status: 'unsubscribed', contact: contacts).empty?
  end
end
