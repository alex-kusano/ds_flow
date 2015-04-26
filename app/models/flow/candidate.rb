class Flow::Candidate < ActiveRecord::Base
  
  # ASSOCIATIONS
  belongs_to :flow_instance
  belongs_to :employment
  
  has_one :role,     through: :employment
  has_one :contact,  through: :employment
  
  # VALIDATIONS
  validates      :flow_instance, :employment, :recipient_id, presence: true
  
  def type 
    'Signer'
  end
end
