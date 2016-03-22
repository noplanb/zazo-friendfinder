class CreateOwners < ActiveRecord::Migration
  def change
    create_table :owners do |t|
      t.string :mkey
      t.boolean :unsubscribed

      t.timestamps
    end

    add_index :owners, :mkey
  end
end
