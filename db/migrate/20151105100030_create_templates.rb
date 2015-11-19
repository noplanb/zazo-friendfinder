class CreateTemplates < ActiveRecord::Migration
  def change
    create_table :templates do |t|
      t.string :category
      t.string :kind
      t.text :content

      t.timestamps
    end
  end
end