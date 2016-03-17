class Notification < ActiveRecord::Base
  include SendingExtension
  include StatusesExtension

  ALLOWED_KINDS = %w(email mobile)
  ALLOWED_STATES = %w(sent error canceled)
  ALLOWED_STATUES = %w(added ignored unsubscribed)
  ALLOWED_CATEGORIES = %w(user_joined fake_user_joined)

  belongs_to :contact

  validates :contact, :nkey, presence: true
  validates :kind, inclusion: { in: ALLOWED_KINDS, message: '%{value} is not a allowed kind' }
  validates :state, inclusion: { in: ALLOWED_STATES, message: '%{value} is not a allowed state' }, allow_nil: true
  validates :status, inclusion: { in: ALLOWED_STATUES, message: '%{value} is not a allowed status' }, allow_nil: true
  validates :category, inclusion: { in: ALLOWED_CATEGORIES, message: '%{value} is not a allowed category' }

  scope :unsubscribed_by_contacts, -> (contacts) { where(status: 'unsubscribed', contact: contacts) }
  scope :by_owner_mkey, -> (owner_mkey) { includes(:contact).where(contacts: { owner_mkey: owner_mkey }) }
  scope :by_state, -> (state) { where(state: state) }
  scope :by_nkey, -> (nkey) { where(nkey: nkey) }

  def self.match_by_contact?(contact)
    !where(contact: contact).empty?
  end
end
