class AddRoutingOrderToFlowFlowInstance < ActiveRecord::Migration
  def change
    add_column :flow_flow_instances, :routing_order, :integer
    add_column :flow_flow_instances, :complete_date, :datetime
    add_reference :flow_flow_instances, :company
  end
end
