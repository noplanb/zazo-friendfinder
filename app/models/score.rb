class Score < ActiveRecord::Base
  ALLOWED_METHODS = %w()

  belongs_to :contact

  validates :contact, :method, :value, presence: true
  validates :value, numericality: true
  validates :method, inclusion: { in: ALLOWED_METHODS, message: '%{value} is not a allowed method' }
end
