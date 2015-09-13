class Score < ActiveRecord::Base
  ALLOWED_METHODS = %w(is_favorite num_vectors num_sms_sent contact_of_users zazo_activity)

  belongs_to :contact

  validates :contact, :name, :value, presence: true
  validates :value, numericality: true
  validates :name, inclusion: { in: ALLOWED_METHODS, message: '%{value} is not a allowed method' }
end
