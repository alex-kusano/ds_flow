module RulesHelper
  
  def get_rule_sets
    RuleSet.all
  end
  
  def get_selected_rule_set( rule )
    if rule.rule_set_id.nil?
      if params[:rule_set_id].nil?
        return "0"
      else
        "#{params[:rule_set_id]}"
      end
    else
      return "#{rule.rule_set_id}"
    end
  end

  
  def build_rule_params( criterium = nil )
    built_params = {}
    built_params[:rule_set_id] = params[:rule_set_id]
    built_params[:rule_id] = params[:id]
    unless criterium.nil?
      built_params[:id] =  criterium.id 
    end
    built_params
  end
end
