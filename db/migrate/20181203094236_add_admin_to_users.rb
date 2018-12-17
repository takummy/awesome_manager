class AddAdminToUsers < ActiveRecord::Migration[5.2]
  def up
    add_column :users, :admin, :boolean, null: false, default: false
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "The initial migration is not reversible."
  end
end
