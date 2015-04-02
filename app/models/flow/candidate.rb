class Flow::Candidate < ActiveRecord::Base
  belongs_to :flow_instance
  belongs_to :employment
  
  has_one :role,     through: :employment
  has_one :contact,  through: :employment
  
  def type 
    'Signer'
  end
end
