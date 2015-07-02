class Company < ActiveRecord::Base
  # ASSOCIATIONS
  has_many  :employments, dependent: :destroy
  has_many  :categories, -> { where(parent_id: nil).order(:priority) }
  
  # VALIDATIONS
  validates     :name, presence: true
  
  # UTILITIES METHODS
  def to_s
    name
  end
    
end
