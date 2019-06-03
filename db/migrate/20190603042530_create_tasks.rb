class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.string :subject, null: false
      t.text :detail

      t.timestamps
    end
  end
end
