module Notification::StatusesExtension
  def added?
    status == 'added'
  end

  def ignored?
    status == 'ignored'
  end

  def unsubscribed?
    status == 'unsubscribed'
  end
end
