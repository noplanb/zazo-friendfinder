class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.string :method
      t.integer :value
      t.references :contact, index: true, foreign_key: true

      t.timestamps
    end
  end
end
