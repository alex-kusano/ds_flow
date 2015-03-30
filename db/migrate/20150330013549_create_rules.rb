class CreateRules < ActiveRecord::Migration
  def change
    create_table :rules do |t|      
      t.timestamps
    end
    
    add_reference :criteria, :rule, index: true
  end
end
