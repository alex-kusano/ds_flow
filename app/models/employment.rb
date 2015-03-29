class Employment < ActiveRecord::Base
  belongs_to :company
  belongs_to :contact
  belongs_to :role
end
