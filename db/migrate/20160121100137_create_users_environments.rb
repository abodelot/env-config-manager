class CreateUsersEnvironments < ActiveRecord::Migration
  def change
    create_table :environments_users do |t|
      t.references :user, index: true, foreign_key: true
      t.references :environment, index: true, foreign_key: true
      t.string :perms, default: 'rw'
      t.timestamps null: false
    end
  end
end
