class CreateFlowFlowInstances < ActiveRecord::Migration
  def change
    create_table :flow_flow_instances do |t|
      t.string :code
      t.string :envelope_id

      t.timestamps
    end
    
    add_index  :flow_flow_instances, [:code, :envelope_id]
  end
end
