class AddUserRefToTasks < ActiveRecord::Migration[5.2]
  def up
    add_reference :tasks, :user
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "The initial migration is not reversible."
  end
end
