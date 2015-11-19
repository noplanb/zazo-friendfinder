class Owner
  attr_reader :mkey

  def initialize(mkey)
    @mkey = mkey
  end

  def contacts
    Contact.by_owner mkey
  end

  def unsubscribed?
    !Notification.where(status: 'unsubscribed', contact: contacts).empty?
  end
end
