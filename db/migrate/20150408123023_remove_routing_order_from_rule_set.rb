class RemoveRoutingOrderFromRuleSet < ActiveRecord::Migration
  def change
    remove_column :rule_sets, :routing_order, :integer
  end
end
