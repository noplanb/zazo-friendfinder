class CreateTemplates < ActiveRecord::Migration
  def change
    create_table :templates do |t|
      t.string :category
      t.string :kind
      t.boolean :is_active
      t.string :content

      t.timestamps
    end
  end
end
