class Vector < ActiveRecord::Base
  ALLOWED_NAMES = %w(mobile email facebook).freeze
  ALLOWED_ADDITIONS = {
    mobile:   %w(sms_messages_sent marked_as_favorite users_with_contact friends_with_contact),
    email:    %w(email_messages_sent marked_as_favorite users_with_contact friends_with_contact),
    facebook: %w(users_with_contact friends_with_contact)
  }.stringify_keys.freeze
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i.freeze

  belongs_to :contact

  validates :contact, :name, :value, presence: true
  validates :name, inclusion: { in: ALLOWED_NAMES, message: '%{value} is not a allowed vector name' }
  validate :additions_must_be_allowed, :value_has_correct_format, unless: 'name.nil?'

  scope :mobile,    -> { where name: 'mobile' }
  scope :email,     -> { where name: 'email' }
  scope :facebook,  -> { where name: 'facebook' }

  def additions_value(key, default = nil)
    (additions.try :[], key) || default
  end

  private

  #
  # validations
  #

  def additions_must_be_allowed
    additions && additions.keys.each do |key|
      errors.add(:additions, "'#{key}' is not allowed condition for '#{name}' vector") unless ALLOWED_ADDITIONS[name].include? key
    end
  end

  def value_has_correct_format
    message = "'#{value}' has incorrect format for '#{name}' vector"
    case name
      when 'mobile'
        errors.add(:value, message) if Normalize.mobile(value).nil?
      when 'email', 'facebook'
        errors.add(:value, message) if (value =~ VALID_EMAIL_REGEX).nil?
    end
  end
end
