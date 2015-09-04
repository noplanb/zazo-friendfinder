class AddConnectionToVectors < ActiveRecord::Migration
  def change
    add_reference :vectors, :connection, index: true, foreign_key: true
  end
end
