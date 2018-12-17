class CreateUsers < ActiveRecord::Migration[5.2]
  def up
    create_table :users do |t|
      t.string :name, null: false, default: "", limit: 60
      t.string :email, null: false, default: "", limit: 300
      t.string :password_digest, null: false, default: ""

      t.timestamps
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "The initial migration is not reversible."
  end
end
