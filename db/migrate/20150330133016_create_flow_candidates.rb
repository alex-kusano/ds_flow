class CreateFlowCandidates < ActiveRecord::Migration
  def change
    create_table :flow_candidates do |t|
      t.references :flow_instance, index: true
      t.integer :routing_order
      t.references :employment, index: true
      t.datetime :sign_date
      t.string :recipient_id

      t.timestamps
    end
    
    add_index :flow_candidates, [:flow_instance_id, :routing_order]
  end
end
