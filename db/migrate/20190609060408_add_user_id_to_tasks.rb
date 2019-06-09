class AddUserIdToTasks < ActiveRecord::Migration[5.2]
  def up
    add_reference :tasks, :user, null: true, foreign_key: true, index: true
    if Task.count != 0
      first_user = User.first
      execute "UPDATE tasks SET user_id = #{first_user.id} WHERE user_id IS NULL;"
    end
    change_column_null :tasks, :user_id, false
  end
  def down
    remove_reference :tasks, :user, index: true
  end
end
