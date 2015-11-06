class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :state
      t.string :status
      t.json :additions
      t.string :nkey
      t.string :compiled_content
      t.references :template, index: true, foreign_key: true

      t.timestamps
    end
  end
end
