class Flow::FlowInstance < ActiveRecord::Base
  
  # ASSOCIATIONS
  has_many :candidates
  belongs_to :company
  belongs_to :sender, class_name: 'Contact'
  
  # VALIDATIONS
  validates      :code, :envelope_id, :routing_order, :company, :sender, presence: true
  
end
