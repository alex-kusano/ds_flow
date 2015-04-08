class RemoveRoutingOrderFromFlowCandidate < ActiveRecord::Migration
  def change
    remove_column :flow_candidates, :routing_order, :integer
  end
end
