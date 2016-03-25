class RemoveCompiledContentFromNotifications < ActiveRecord::Migration
  def change
    remove_column :notifications, :compiled_content, :text
  end
end
