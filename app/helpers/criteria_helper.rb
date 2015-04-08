module CriteriaHelper
  
  def get_roles
    Role.all
  end
  
  def get_rules
    Rule.all
  end
  
  def get_selected_rule( criterium )
    if criterium.rule_id.nil?
      if params[:rule_id].nil?
        return "0"
      else
        "#{params[:rule_id]}"
      end
    else
    return "#{criterium.rule_id}"
    end
  end

  def get_selected_role( criterium )
    if criterium.role_id.nil?
      return "0"
    else
      return "#{criterium.role_id}"
    end
  end

  def get_back_path
    unless params[:rule_id].nil?
      return rule_path( id: params[:rule_id], rule_set_id: params[:rule_set_id] )
    end
    criteria_path
  end

end

  
