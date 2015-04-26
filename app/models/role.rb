class Role < ActiveRecord::Base  
  
  # VALIDATIONS
  validates      :name, presence: true
  
  # UTILITIES METHODS
  def to_s
    name
  end
end
