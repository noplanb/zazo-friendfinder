class Owner
  attr_reader :mkey, :full_name

  class << self
    def all
      uniq_mkeys.map { |owner_mkey| new(owner_mkey) }
    end

    def count
      uniq_mkeys.size
    end

    def subscribed
      all.select { |owner| !owner.unsubscribed? }
    end

    private

    def uniq_mkeys
      Contact.uniq.pluck(:owner_mkey)
    end
  end

  def initialize(mkey)
    @mkey = mkey
  end

  def fetch_data
    attributes = DataProviderApi.new(user: mkey, attrs: [:first_name, :last_name]).query(:attributes) rescue nil
    @full_name = "#{attributes['first_name']} #{attributes['last_name']}" if attributes
    self
  end

  def contacts
    Contact.by_owner(mkey).order_by_score.with_notifications
  end

  def notifications
    Notification.by_owner_mkey(mkey)
  end

  def unsubscribed?
    !Notification.unsubscribed_by_contacts(contacts).empty?
  end
end
