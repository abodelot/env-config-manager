class CreateUsersEnvironments < ActiveRecord::Migration
  def change
    create_table :environments_users do |t|
      t.references :user, index: true, foreign_key: true
      t.references :environment, index: true, foreign_key: true
      t.boolean :write_access, default: true
      t.timestamps null: false
    end
    add_index :environments_users, [:user_id, :environment_id], unique: true
  end
end
