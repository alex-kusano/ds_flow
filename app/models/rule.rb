class Rule < ActiveRecord::Base
  # ASSOCIATIONS
  belongs_to :rule_set
  has_many   :criteria
  
  #VALIDATIONS
  validates    :rule_set, presence: true
  
  # UTITLITY METHODS
  def to_s
    if criteria.blank?
      "No Criteria!"
    else
      criteria.to_a.join(' AND ')
    end
  end
  
  def validate_rule( count_map )
    
    criteria.each do |criterium|
      return false unless criterium.validate_criterium( count_map )
    end    
    
    return true
  end
  
  
end
