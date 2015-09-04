class CreateConnections < ActiveRecord::Migration
  def change
    create_table :connections do |t|
      t.string :owner
      t.string :first_name
      t.string :last_name
      t.integer :total_score
      t.datetime :expires_at

      t.timestamps
    end
    add_index :connections, :owner
  end
end
