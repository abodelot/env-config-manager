class CreateEnvironmentsUsers < ActiveRecord::Migration
  def change
    create_table :environments_users do |t|
      t.references :user, :null => false, :index => true
      t.references :environment, :null => false, :index => true
      t.timestamps null: false
    end
  end
end
