class Vector < ActiveRecord::Base
  belongs_to :connection

  validates :name, :value, presence: true
end
