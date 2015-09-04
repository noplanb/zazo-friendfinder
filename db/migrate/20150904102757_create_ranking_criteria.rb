class CreateRankingCriteria < ActiveRecord::Migration
  def change
    create_table :ranking_criteria do |t|
      t.string :method
      t.integer :score
      t.references :connection, index: true, foreign_key: true

      t.timestamps
    end
  end
end
