class CreateEnvironments < ActiveRecord::Migration
  def change
    create_table :environments do |t|
      t.string :name, null: false, index: true
      t.string :ancestry
      t.timestamps null: false
    end
    add_index :environments, :ancestry
  end
end
