class Owner
  include Extensions::Subscription
  include Extensions::ExternalData
  include Extensions::ContactsActions

  attr_reader :mkey

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

  def contacts
    Contact.by_owner(mkey).order_by_score.with_notifications
  end

  def notifications
    Notification.by_owner_mkey(mkey).order(:id)
  end

  def additions(reload: false)
    return @additions if @additions && !reload
    @additions = Additions.by_mkey(mkey)
  end
end
