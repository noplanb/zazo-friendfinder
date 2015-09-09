class Vector < ActiveRecord::Base
  belongs_to :contact

  validates :contact, :name, :value, presence: true

  scope :mobile, -> { where name: 'mobile' }
  scope :email,  -> { where name: 'email' }

  def additions_value(key, default = nil)
    (additions.try :[], key) || default
  end
end
