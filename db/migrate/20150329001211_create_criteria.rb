class CreateCriteria < ActiveRecord::Migration
  def change
    create_table :criteria do |t|      
      t.belongs_to   :role,     index: true
      t.integer      :count

      t.timestamps
    end
  end
end
