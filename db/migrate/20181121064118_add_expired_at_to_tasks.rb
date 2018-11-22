class AddExpiredAtToTasks < ActiveRecord::Migration[5.2]
  def up
    add_column :tasks, :expired_at, :date, default: "", null: false
  end

  def down
    raise Activerecord::IrreversibleMigration, "The initial migration is not reversible."
  end
end