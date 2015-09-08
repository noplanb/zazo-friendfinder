class Score < ActiveRecord::Base
  ALLOWED_METHODS = %w(is_this_contact_favorite number_of_vectors)

  belongs_to :contact

  validates :contact, :name, :value, presence: true
  validates :value, numericality: true
  validates :name, inclusion: { in: ALLOWED_METHODS, message: '%{value} is not a allowed method' }
end
