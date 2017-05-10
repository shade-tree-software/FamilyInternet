class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.boolean :active
      t.integer :countdown

      t.timestamps
    end
  end
end
