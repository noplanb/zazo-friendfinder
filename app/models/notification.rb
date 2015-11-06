class Notification < ActiveRecord::Base
  ALLOWED_STATES = %w(send error)
  ALLOWED_STATUES = %w(added ignored unsubscribed)

  belongs_to :template
  belongs_to :contact

  validates :contact, :template, :compiled_content, presence: true
  validates :state, inclusion: { in: ALLOWED_STATES, message: '%{value} is not a allowed state' }, allow_nil: true
  validates :status, inclusion: { in: ALLOWED_STATUES, message: '%{value} is not a allowed status' }, allow_nil: true
end
