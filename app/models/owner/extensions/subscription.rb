module Owner::Extensions::Subscription
  def unsubscribe
    return if unsubscribed?
    if additions
      additions.update_attributes(unsubscribed: true)
    else
      Owner::Additions.create(mkey: mkey, unsubscribed: true)
    end
  end

  def subscribe
    return if subscribed?
    additions.update_attributes(unsubscribed: false) if additions
  end

  def unsubscribed?
    additions && additions.unsubscribed
  end

  def subscribed?
    !unsubscribed?
  end
end
