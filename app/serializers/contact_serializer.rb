class ContactSerializer < ActiveModel::Serializer
  attributes :first_name, :last_name, :display_name, :zazo_mkey, :zazo_id, :total_score
end
