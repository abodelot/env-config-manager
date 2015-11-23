class CreateEnvironmentsUsers < ActiveRecord::Migration
  def change
    create_table :environments_users do |t|
      t.references :user, :null => false
      t.references :environment, :null => false
      t.timestamps null: false
    end
    add_index :environments_users, [:user_id, :environment_id], :unique => true
  end
end
