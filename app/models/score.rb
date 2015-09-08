class Score < ActiveRecord::Base
  ALLOWED_METHODS = %w(is_this_contact_favorite number_of_vectors others_having_this_contact sms_frequency)

  belongs_to :contact

  validates :contact, :name, :value, presence: true
  validates :value, numericality: true
  validates :name, inclusion: { in: ALLOWED_METHODS, message: '%{value} is not a allowed method' }
end
