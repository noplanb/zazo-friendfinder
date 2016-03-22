module Contact::AdditionsExtension
  def additions_value(key, default = nil)
    value = additions.try(:[], key)
    value.nil? ? default : value
  end

  def marked_as_friend?
    additions_value('marked_as_friend')
  end

  def marked_as_favorite?
    additions_value('marked_as_favorite', false)
  end

  def rejected?
    additions_value('rejected_by_owner', false)
  end

  def added?
    additions_value('added_by_owner', false)
  end
end
