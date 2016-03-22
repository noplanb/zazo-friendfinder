module Contact::Extensions::Filters
  def notified?
    Notification.match_by_contact?(self)
  end
end
