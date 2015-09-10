class Score < ActiveRecord::Base
  ALLOWED_METHODS = %w(is_contact_favorite is_contact_registered_on_zazo number_of_vectors others_having_this_contact sms_frequency activity_on_zazo)

  belongs_to :contact

  validates :contact, :name, :value, presence: true
  validates :value, numericality: true
  validates :name, inclusion: { in: ALLOWED_METHODS, message: '%{value} is not a allowed method' }
end
