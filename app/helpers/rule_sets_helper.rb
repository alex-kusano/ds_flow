module RuleSetsHelper
  def build_rule_set_params( rule = nil )
    built_params = {}
    built_params[:rule_set_id] = params[:id]
    unless rule.nil?
      built_params[:id] =  rule.id 
    end
    built_params
  end
end
