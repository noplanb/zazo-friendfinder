class Contact < ActiveRecord::Base
  include OwnerExtension
  include FilterExtension
  include AdditionsExtension

  ALLOWED_ADDITIONS = [
    'marked_as_favorite', # attrs coming from client
    'rejected_by_owner', 'recommended_by', # attrs for persist contact status data, cannot be reproduced
    'users_with_contact', 'friends_with_contact', 'friends_who_are_friends_with_contact', # attrs for caching criteria data
    'marked_as_friend' # additional caching
  ]

  has_many :vectors, dependent: :destroy
  has_many :scores, dependent: :destroy
  has_many :notifications

  validates :owner_mkey, presence: true
  validate :additions_must_be_allowed

  scope :with_notifications, -> { includes(:notifications) }

  scope :by_owner, -> (owner_mkey) { where(owner_mkey: owner_mkey) }
  scope :order_by_score, -> { order('total_score DESC') }
  scope :expired, -> { where('expires_at < ?', Time.now) }

  scope :not_equals_with_owner, -> { where('contacts.owner_mkey != contacts.zazo_mkey OR contacts.zazo_mkey IS NULL') }

  scope :proposed, -> { with_notifications.where.not(notifications: { id: nil }) }
  scope :not_proposed, -> { with_notifications.where(notifications: { id: nil }) }

  scope :not_friends, -> { not_equals_with_owner.where("contacts.additions->>'marked_as_friend' = 'false'") }
  scope :friends, -> { not_equals_with_owner.where("contacts.additions->>'marked_as_friend' = 'true'") }

  scope :rejected, -> { where("contacts.additions->>'rejected_by_owner' = 'true'") }
  scope :not_rejected, -> { where("(contacts.additions->>'rejected_by_owner') IS NULL") }

  scope :suggestible, -> { not_rejected.not_proposed.not_friends }

  before_save { self.expires_at = 5.days.from_now }

  private

  #
  # validations
  #

  def additions_must_be_allowed
    additions && additions.keys.each do |key|
      errors.add(:additions, "'#{key}' is not allowed addition") unless ALLOWED_ADDITIONS.include?(key)
    end
  end
end
