class CreateGroups < ActiveRecord::Migration[7.0]
  def change
    create_table :groups do |t|
      t.text :name
      t.binary :variables

      t.timestamps
    end
  end
end
