class AddExternalIdToDsAccounts < ActiveRecord::Migration
  def change
    add_column :ds_accounts, :external_id, :integer
    add_column :ds_accounts, :base_url, :string
    add_column :ds_accounts, :user_id, :string
  end
end
