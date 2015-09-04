class Connection < ActiveRecord::Base
  has_many :vectors
  has_many :ranking_criterias
end
