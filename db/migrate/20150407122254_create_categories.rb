class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.references :company,   index: true
      t.string :tab_name
      t.string :tab_value
      t.integer :datatype
      t.integer :operation
      t.string :code
      t.references :parent,   index: true
      t.timestamps
    end
  end
end
