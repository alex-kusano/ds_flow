class Criterium < ActiveRecord::Base
  belongs_to :rule
  belongs_to :role
  
  def validate_criterium( count_map )
    role_count = count_map[self.role_id]
    !role_count.nil? && role_count >= self.count
  end
  
  def to_s
    "#{role}x#{count}"
  end
end
