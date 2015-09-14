class Contact < ActiveRecord::Base
  has_many :vectors
  has_many :scores

  # todo: add validations for additions field

  validates :owner, presence: true

  scope :by_owner, -> (owner) { where(owner: owner).order('total_score DESC') }

  before_save do
    self.expires_at = 5.days.from_now
  end

end
