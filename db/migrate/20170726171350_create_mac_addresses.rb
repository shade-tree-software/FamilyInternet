class CreateMacAddresses < ActiveRecord::Migration[5.1]
  def up
    create_table :mac_addresses do |t|
      t.string :mac
      t.integer :user_id

      t.timestamps
    end

    users = ActiveRecord::Base.connection.exec_query "select id, mac_address from users"
    users.each do |user|
      ActiveRecord::Base.connection.exec_query "insert into mac_addresses set mac=\'#{user['mac_address']}\', user_id=#{user['id']}, created_at=NOW(), updated_at=NOW()"
    end
  end

  def down
    drop_table :mac_addresses
  end
end
