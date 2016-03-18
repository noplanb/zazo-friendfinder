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
end
