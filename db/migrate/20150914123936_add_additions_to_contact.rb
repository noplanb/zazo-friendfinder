class AddAdditionsToContact < ActiveRecord::Migration
  def change
    add_column :contacts, :additions, :json
  end
end
