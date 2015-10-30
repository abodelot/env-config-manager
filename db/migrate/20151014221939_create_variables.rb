class CreateVariables < ActiveRecord::Migration
  def change
    create_table :variables do |t|
      t.string :key, null: false
      t.string :value, null: false
      t.integer :environment_id, null: false
      t.timestamps null: false
    end
    add_index :variables, :environment_id
    add_index :variables, [:key, :environment_id], unique: true
  end
end
