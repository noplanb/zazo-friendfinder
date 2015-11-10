class Template < ActiveRecord::Base
  ALLOWED_KINDS = %w(email mobile_notification)
  ALLOWED_CATEGORIES = %w(user_joined fake_user_joined)

  has_many :notifications

  validates :category, :kind, :content, presence: true
  validates :category, inclusion: { in: ALLOWED_CATEGORIES, message: '%{value} is not a allowed category' }
  validates :kind, inclusion: { in: ALLOWED_KINDS, message: '%{value} is not a allowed kind' }
  validates_with UniqueKindCategory
end
