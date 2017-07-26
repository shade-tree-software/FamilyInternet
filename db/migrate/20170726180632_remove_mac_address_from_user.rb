class RemoveMacAddressFromUser < ActiveRecord::Migration[5.1]
  def up
    remove_column :users, :mac_address, :string
  end

  def down
    add_column :users, :mac_address, :string

    mac_addresses = ActiveRecord::Base.connection.exec_query "select user_id, mac from mac_addresses"
    mac_addresses.each do |mac|
      ActiveRecord::Base.connection.exec_query "update users set mac_address=\'#{mac['mac']}\' where id=#{mac['user_id']}"
    end
  end
end
