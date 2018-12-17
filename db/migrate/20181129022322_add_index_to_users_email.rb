class AddIndexToUsersEmail < ActiveRecord::Migration[5.2]
  def up
    add_index :users, :email, unique: true
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "The initial migration is not reversible."
  end
end
