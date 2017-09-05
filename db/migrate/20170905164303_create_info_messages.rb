class CreateInfoMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :info_messages do |t|
      t.string :text
      t.boolean :active
      t.timestamps
    end
  end
end
