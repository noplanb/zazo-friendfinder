class ChangeTypeOfCompiledContentOnNotifications < ActiveRecord::Migration
  def change
    change_column :notifications, :compiled_content, :text
  end
end
