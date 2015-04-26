class ConnectConfig < ActiveRecord::Base
  
  # ASSOCIATIONS
  has_many :accounts, foreign_key: 'external_id', class_name: 'DsAccount', primary_key: 'account_id'
  
  # VALIDATIONS
  validates      :send_interface_id, :sign_interface_id, :account_id, presence: true
  
end

