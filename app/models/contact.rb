class Contact < ActiveRecord::Base
  has_many :vectors
  has_many :scores

  validates :owner, :expires_at, presence: true
end
