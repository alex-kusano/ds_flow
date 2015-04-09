class ConnectConfig < ActiveRecord::Base
  has_many :accounts, foreign_key: 'external_id', class_name: 'DsAccount', primary_key: 'account_id'
end

