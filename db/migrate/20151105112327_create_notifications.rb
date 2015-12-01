class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :kind
      t.string :state
      t.string :status
      t.string :category
      t.json :additions
      t.string :nkey
      t.string :compiled_content

      t.timestamps
    end
  end
end
