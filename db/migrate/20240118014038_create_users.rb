class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :login
      t.string :encrypted_password
      t.string :salt
      t.string :first_name
      t.string :last_name
    end
  end
end
