class CreateKeys < ActiveRecord::Migration
  def change
    create_table :variables do |t|
      t.string :key, null: false, index: true
      t.string :value
      t.references :environment, index: true, foreign_key: true
      t.timestamps null: false
    end
    add_index :variables, [:key, :environment_id], :unique => true
  end
end
