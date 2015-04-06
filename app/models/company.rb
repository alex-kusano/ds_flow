class Company < ActiveRecord::Base
  has_many  :employments
  
  def to_s
    name
  end
    
end
