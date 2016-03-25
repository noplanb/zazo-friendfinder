class Notification < ActiveRecord::Base
  include Extensions::Sending
  include Extensions::Compiling
  include AASM

  ALLOWED_KINDS = %w(email mobile)
  ALLOWED_STATES = %w(sent error canceled)
  ALLOWED_STATUES = %w(no_feedback added ignored)
  ALLOWED_CATEGORIES = %w(user_joined fake_user_joined)

  belongs_to :contact

  validates :contact, :nkey, presence: true
  validates :kind, inclusion: { in: ALLOWED_KINDS, message: '%{value} is not a allowed kind' }
  validates :state, inclusion: { in: ALLOWED_STATES, message: '%{value} is not a allowed state' }, allow_nil: true
  validates :status, inclusion: { in: ALLOWED_STATUES, message: '%{value} is not a allowed status' }, allow_nil: true
  validates :category, inclusion: { in: ALLOWED_CATEGORIES, message: '%{value} is not a allowed category' }

  aasm column: :status do
    state :no_feedback, initial: true
    state :added
    state :ignored

    event :set_added do
      transitions from: [:no_feedback, :ignored], to: :added
    end

    event :set_ignored do
      transitions from: [:no_feedback], to: :ignored
    end
  end

  scope :by_owner_mkey, -> (owner_mkey) { includes(:contact).where(contacts: { owner_mkey: owner_mkey }) }
  scope :by_state, -> (state) { where(state: state) }
  scope :by_nkey, -> (nkey) { where(nkey: nkey) }

  def self.match_by_contact?(contact)
    !where(contact: contact).empty?
  end
end
