class ContactSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :display_name, :zazo_mkey, :zazo_id, :total_score

  has_many :vectors
end
