class ContactSerializer < ActiveModel::Serializer
  attributes :first_name, :last_name, :total_score
end
