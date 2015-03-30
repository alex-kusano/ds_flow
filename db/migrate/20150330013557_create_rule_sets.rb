class CreateRuleSets < ActiveRecord::Migration
  def change
    create_table :rule_sets do |t|
      t.string     :code
      t.integer    :routing_order
      
      t.timestamps
    end
    
    add_reference :rules, :rule_set, index: true
  end
end
