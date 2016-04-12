class NotificationSerializer < ActiveModel::Serializer
  attributes :id, :kind, :state, :status, :category, :nkey

  has_one :contact
end
