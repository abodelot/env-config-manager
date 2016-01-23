class CreateEnvironments < ActiveRecord::Migration
  def change
    create_table :environments do |t|
      t.string :name, null: false
      t.string :ancestry
      t.timestamps null: false
    end
    add_index :environments, :name,  unique: true
    add_index :environments, :ancestry
  end
end
