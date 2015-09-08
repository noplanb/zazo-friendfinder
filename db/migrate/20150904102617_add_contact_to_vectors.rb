class AddContactToVectors < ActiveRecord::Migration
  def change
    add_reference :vectors, :contact, index: true, foreign_key: true
  end
end
