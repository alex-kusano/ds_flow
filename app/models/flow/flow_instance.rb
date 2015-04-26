class Flow::FlowInstance < ActiveRecord::Base
  
  # ASSOCIATIONS
  has_many :candidates
  belongs_to :company
  
  # VALIDATIONS
  validates      :code, :envelope_id, :routing_order, :company, presence: true
  
end
