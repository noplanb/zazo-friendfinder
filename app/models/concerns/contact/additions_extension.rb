module Contact::AdditionsExtension
  def additions_value(key, default = nil)
    (additions.try :[], key) || default
  end

  def marked_as_friend?
    additions_value('marked_as_friend', false)
  end

  def marked_as_favorite?
    additions_value('marked_as_favorite', false)
  end
end
