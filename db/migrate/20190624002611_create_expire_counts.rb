class CreateExpireCounts < ActiveRecord::Migration[5.2]
  def change
    create_table :expire_counts do |t|
      t.references :user, foreign_key: true
      t.integer :expired_count, null: false, default: 0
      t.integer :expiring_count, null: false, default: 0
      t.integer :expiring_hours, null: false, default: 24

      t.timestamps
    end
  end
end
