class AddNotNullConstraints < ActiveRecord::Migration
  def up
    change_column :environments_users, :user_id, :integer, :null => false
    change_column :environments_users, :environment_id, :integer, :null => false
    change_column :environments_users, :perms, :string, :null => false
    change_column :variables, :environment_id, :integer, :null => false
    change_column :variables, :value, :string, :null => false
  end

  def down
    change_column :environments_users, :user_id, :integer, :null => true
    change_column :environments_users, :environment_id, :integer, :null => true
    change_column :environments_users, :perms, :string, :null => true
    change_column :variables, :environment_id, :integer, :null => true
    change_column :variables, :value, :string, :null => true
  end
end
