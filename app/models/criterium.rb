class Criterium < ActiveRecord::Base
  
  # ASSOCIATIONS
  belongs_to :rule
  belongs_to :role
  
  # VALIDATIONS
  validates      :role, :count, :rule, presence: true
  validate       :positiveCount?
  
  # UTILITY METHODS
  def validate_criterium( count_map )
    role_count = count_map[self.role_id]
    !role_count.nil? && role_count >= self.count
  end
  
  def to_s
    "#{role}x#{count}"
  end
  
  def positiveCount?
    if count.nil? || count <= 0 
      errors.add(:count, "must be positive integer" )
    end
  end
end
