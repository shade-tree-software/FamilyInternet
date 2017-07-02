class AddTimeWindowToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :wakeup, :string, default: '06:00'
    add_column :users, :bedtime, :string, default: '21:00'
  end
end
