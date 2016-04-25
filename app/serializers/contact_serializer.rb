class ContactSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :display_name, :zazo_mkey, :zazo_id, :total_score, :phone_numbers

  has_many :vectors

  def phone_numbers
    vectors.mobile.pluck(:value)
  end
end
