class AddNotNullConstraints < ActiveRecord::Migration
  def up
    change_column :environments_users, :user_id, :integer, :null => false
    change_column :environments_users, :environment_id, :integer, :null => false
    change_column :variables, :environment_id, :integer, :null => false
  end

  def down
    change_column :environments_users, :user_id, :integer, :null => true
    change_column :environments_users, :environment_id, :integer, :null => true
    change_column :variables, :environment_id, :integer, :null => true
  end
end
