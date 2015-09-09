class AddZazoIdAndZazoMkeyToContact < ActiveRecord::Migration
  def change
    add_column :contacts, :zazo_id, :integer
    add_column :contacts, :zazo_mkey, :string
  end
end
