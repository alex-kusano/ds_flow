class Rule < ActiveRecord::Base
  belongs_to :rule_set
  has_many   :criteria
  
  def validate_rule( count_map )
    
    criteria.each do |criterium|
      return false unless criterium.validate_criterium( count_map )
    end    
    
    return true
  end
end
