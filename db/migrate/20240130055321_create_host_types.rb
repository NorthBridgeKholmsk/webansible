class CreateHostTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :host_types do |t|
      t.text :id_type
      t.text :name
    end
  end
end
