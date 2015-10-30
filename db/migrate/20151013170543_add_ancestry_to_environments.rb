class AddAncestryToEnvironments < ActiveRecord::Migration
  def up
    add_column :environments, :ancestry, :string
    add_index :environments, :ancestry
  end

  def down
    remove_index :environments, :ancestry
    remove_column :environments, :ancestry
  end
end
