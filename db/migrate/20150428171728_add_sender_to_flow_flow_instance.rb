class AddSenderToFlowFlowInstance < ActiveRecord::Migration
  def change
    add_column    :flow_flow_instances, :account_id, :integer, index: true
    add_reference :flow_flow_instances, :sender, index: true 
    
  end
end
