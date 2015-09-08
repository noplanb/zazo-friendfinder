class Vector < ActiveRecord::Base
  belongs_to :connection

  validates :connection, :name, :value, presence: true

  scope :mobile, -> { where name: 'mobile' }

  def additions_value(key, default = nil)
    (additions.try :[], key) || default
  end
end
