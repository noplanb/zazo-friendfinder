class Connection < ActiveRecord::Base
  has_many :vectors
  has_many :ranking_criterias

  validates :owner, :expires_at, presence: true
end
