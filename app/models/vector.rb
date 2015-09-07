class Vector < ActiveRecord::Base
  belongs_to :connection

  validates :connection, :name, :value, presence: true
end
