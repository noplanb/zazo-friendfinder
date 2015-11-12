class Notification < ActiveRecord::Base
  ALLOWED_STATES = %w(send error)
  ALLOWED_STATUES = %w(added ignored unsubscribed)
  ALLOWED_CATEGORIES = %w(user_joined fake_user_joined)

  belongs_to :template
  belongs_to :contact

  validates :contact, :compiled_content, presence: true
  validates :state, inclusion: { in: ALLOWED_STATES, message: '%{value} is not a allowed state' }, allow_nil: true
  validates :status, inclusion: { in: ALLOWED_STATUES, message: '%{value} is not a allowed status' }, allow_nil: true
  validates :category, inclusion: { in: ALLOWED_CATEGORIES, message: '%{value} is not a allowed category' }

  def match_by_contact?

  end
end
