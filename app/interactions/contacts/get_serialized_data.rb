class Contacts::GetSerializedData < ActiveInteraction::Base
  object :contact

  def execute
    ContactSerializer.new(contact, except: :phone_numbers).serializable_hash
  end
end
