class AddDisplayNameToContact < ActiveRecord::Migration
  def change
    add_column :contacts, :display_name, :string
  end
end
