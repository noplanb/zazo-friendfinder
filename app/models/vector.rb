class Vector < ActiveRecord::Base
  belongs_to :contact

  validates :contact, :name, :value, presence: true

  scope :mobile, -> { where name: 'mobile' }

  def additions_value(key, default = nil)
    (additions.try :[], key) || default
  end
end
