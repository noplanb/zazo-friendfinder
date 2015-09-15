class Contact < ActiveRecord::Base
  ALLOWED_ADDITIONS = %w(marked_as_favorite rejected_by_owner recommended_by)

  has_many :vectors
  has_many :scores

  validates :owner, presence: true
  validate :additions_must_be_allowed

  scope :by_owner, -> (owner) { where(owner: owner).order('total_score DESC') }

  before_save { self.expires_at = 5.days.from_now }

  def additions_value(key, default = nil)
    (additions.try :[], key) || default
  end

  private

  #
  # validations
  #

  def additions_must_be_allowed
    additions && additions.keys.each do |key|
      errors.add(:additions, "'#{key}' is not allowed addition") unless ALLOWED_ADDITIONS.include? key
    end
  end
end
