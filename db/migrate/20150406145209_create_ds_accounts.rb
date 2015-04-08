class CreateDsAccounts < ActiveRecord::Migration
  def change
    create_table :ds_accounts do |t|
      t.string :username
      t.string :email
      t.string :token

      t.timestamps
    end
  end
end
