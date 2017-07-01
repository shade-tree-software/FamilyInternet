class AddDateInfoToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :today, :date
    add_column :users, :minutes_per_day, :integer, default: 60
  end
end
