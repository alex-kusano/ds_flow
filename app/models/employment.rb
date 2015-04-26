class Employment < ActiveRecord::Base
  # ASSOCIATIONS
  belongs_to :company
  belongs_to :contact
  belongs_to :role
  
  # VALIDATIONS
  validates      :company, :role, :contact, presence: true
end
