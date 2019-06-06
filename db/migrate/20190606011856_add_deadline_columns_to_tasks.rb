class AddDeadlineColumnsToTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :deadline_date, :date
    add_column :tasks, :deadline_time, :time
  end
end
