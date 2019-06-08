class AddPriorityColumnToTask < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :priority, :integer, null: false, default: 3
    add_index :tasks, :priority
  end
end
