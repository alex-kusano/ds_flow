class Company < ActiveRecord::Base
  has_many  :employments
  has_many  :categories, -> { where(parent_id: nil) }
  
  def to_s
    name
  end
    
end
