class Contact < ActiveRecord::Base
  has_many :vectors
  has_many :scores

  validates :owner, :expires_at, presence: true

  scope :by_owner, -> (owner) { where(owner: owner).order('total_score DESC') }
end
