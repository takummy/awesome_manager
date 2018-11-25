class AddStateToTasks < ActiveRecord::Migration[5.2]
  def up
    add_column :tasks, :state, :integer, null: false, default: ""
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "The initial migration is not reversible."
  end
end
