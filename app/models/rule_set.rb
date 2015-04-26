class RuleSet < ActiveRecord::Base
  # ASSOCIATIONS
  has_many :rules
  
  # VALIDATIONS
  validates      :code, presence: true
  
  #SCOPES
  scope :by_code, -> param { where( RuleSet.arel_table[:code].matches("%#{param}%") ) }
  
  # UTITLITY METHODS
  def validate_rule_set( count_map )
    
    rules.each do |rule|
      return true if rule.validate_rule( count_map )
    end
    
    return false
  end
  
  def to_s
    if( rules.blank? )
      "No Rule!"
    else
      "(#{rules.to_a.join(') OR (')})"
    end
  end
  
  #####################################################################
  # Class Methods
  #####################################################################
  
  def self.get_rule_sets( code )    
    RuleSet.where( code: code ).joins( rules: [ criteria: :role ] ).includes( rules: [ criteria: :role ] )
  end
  
  def self.get_associated_role_ids( code )
    role_ids = Criterium.distinct.joins(rule: [:rule_set]).where(rule_sets: {code: code}).pluck(:role_id)    
  end
  
end
