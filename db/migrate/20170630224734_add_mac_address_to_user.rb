class AddMacAddressToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :mac_address, :string
  end
end
