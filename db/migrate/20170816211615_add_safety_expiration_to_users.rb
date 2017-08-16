class AddSafetyExpirationToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :safety_expiration, :integer
  end
end
