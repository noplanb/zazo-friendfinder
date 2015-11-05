class Template < ActiveRecord::Base
  ALLOWED_KINDS = %w(email mobile_notification)
  ALLOWED_CATEGORIES = %w(user_joined fake_user_joined)

  validates :category, :kind, :is_active, :content, presence: true
  validates :category, inclusion: { in: ALLOWED_CATEGORIES, message: '%{value} is not a allowed template category' }
  validates :kind, inclusion: { in: ALLOWED_KINDS, message: '%{value} is not a allowed template kind' }
end
