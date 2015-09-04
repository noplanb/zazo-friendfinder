class RankingCriteria < ActiveRecord::Base
  ALLOWED_METHODS = %w()

  belongs_to :connection

  validates :connection, :method, :score, presence: true
  validates :score, numericality: true
  validates :method, inclusion: { in: ALLOWED_METHODS, message: '%{value} is not a allowed method' }
end
