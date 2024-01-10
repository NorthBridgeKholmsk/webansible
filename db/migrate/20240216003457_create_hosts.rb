class CreateHosts < ActiveRecord::Migration[7.0]
  def change
    create_table :hosts do |t|
      t.text :hostname
      t.text :address
      t.text :login
      t.text :password
      t.belongs_to :host_type
      t.text :os
      t.text :host_role
      t.belongs_to :group
    end
  end
end
