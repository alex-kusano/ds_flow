class CreateConnectConfigs < ActiveRecord::Migration
  def change
    create_table :connect_configs do |t|
      t.integer :send_interface_id
      t.integer :sign_interface_id
      t.integer :account_id,     index = true
      
      t.timestamps
    end    
  end
end
