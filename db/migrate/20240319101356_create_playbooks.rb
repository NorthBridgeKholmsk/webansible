class CreatePlaybooks < ActiveRecord::Migration[7.0]
  def change
    create_table :playbooks do |t|
      t.text :name
      t.text :comment
      t.text :lin_tasks
      t.text :win_tasks
    end
  end
end
