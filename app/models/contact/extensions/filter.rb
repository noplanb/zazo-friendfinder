module Contact::Extensions::Filter
  def notified?
    Notification.match_by_contact?(self)
  end
end
