class RuleSet < ActiveRecord::Base
  has_many :rules
  
  def validate_rule_set( count_map )
    
    rules.each do |rule|
      return true if rule.validate_rule( count_map )
    end
    
    return false
  end
  
  def to_s
    "#{code}@#{routing_order}"
  end
  
  #####################################################################
  # Class Methods
  #####################################################################
  
  def self.get_rule_sets( code, routing_order )    
    RuleSet.where( code: code, routing_order: routing_order ).joins( rules: [ criteria: :role ] ).includes( rules: [ criteria: :role ] )
  end
  
  def self.get_associated_role_ids( code, routing_order )
    role_ids = Criterium.distinct.joins(rule: [:rule_set]).where(rule_sets: {code: code, routing_order: routing_order}).pluck(:role_id)    
  end
  
end
