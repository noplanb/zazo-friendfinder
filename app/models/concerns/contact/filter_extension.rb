module Contact::FilterExtension
  def notified?
    Notification.match_by_contact? self
  end
end
