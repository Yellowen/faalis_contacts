class CreateContactFields < ActiveRecord::Migration
  def change
    create_table :contact_fields do |t|
      t.string :name
      t.string :value_type
      t.text :validation_rules
      t.timestamps
    end
  end
end
