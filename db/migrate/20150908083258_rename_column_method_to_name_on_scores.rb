class RenameColumnMethodToNameOnScores < ActiveRecord::Migration
  def change
    rename_column :scores, :method, :name
  end
end
