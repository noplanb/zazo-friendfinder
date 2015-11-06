class AddContactToNotification < ActiveRecord::Migration
  def change
    add_reference :notifications, :contact, index: true, foreign_key: true
  end
end
