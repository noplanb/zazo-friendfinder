class Score < ActiveRecord::Base
  ALLOWED_METHODS = %w(is_favorite num_vectors num_sms_sent contact_of_users contact_of_friends friend_of_friends recommended_by_friends zazo_activity)

  belongs_to :contact

  validates :contact, :name, :value, presence: true
  validates :value, numericality: true
  validates :name, inclusion: { in: ALLOWED_METHODS, message: '%{value} is not a allowed method' }
end
