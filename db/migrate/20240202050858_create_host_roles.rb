class CreateHostRoles < ActiveRecord::Migration[7.0]
  def change
    create_table :host_roles do |t|
      t.text :id_role
      t.text :name

      t.timestamps
    end
  end
end
