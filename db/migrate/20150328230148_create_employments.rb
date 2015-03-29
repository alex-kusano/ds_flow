class CreateEmployments < ActiveRecord::Migration
  def change
    create_table :employments do |t|
      t.belongs_to :company,    index: true
      t.belongs_to :contact,    index: true
      t.belongs_to :role
      t.timestamps
    end
    
    add_index  :employments, [:company_id, :role_id]
  end
end
