class DsAccount < ActiveRecord::Base  
  # VALIDATIONS
  validates     :company, :contact, :role, presence: true
end
