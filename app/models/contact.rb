class Contact < ActiveRecord::Base
  ALLOWED_ADDITIONS = [
    'marked_as_favorite', # attrs coming from client
    'rejected_by_owner', 'recommended_by', # attrs for persist contact status data, cannot be reproduced
    'users_with_contact', 'friends_with_contact', 'friends_who_are_friends_with_contact' # attrs for caching criteria data
  ]

  has_many :vectors
  has_many :scores

  validates :owner, presence: true
  validate :additions_must_be_allowed

  scope :by_owner, -> (owner) { where(owner: owner).order('total_score DESC') }
  scope :expired,  -> { where 'expires_at < ?', Time.now }

  before_save { self.expires_at = 5.days.from_now }

  def additions_value(key, default = nil)
    (additions.try :[], key) || default
  end

  def owner_instance
    Owner.new owner
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
