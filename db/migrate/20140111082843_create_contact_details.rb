class CreateContactDetails < ActiveRecord::Migration
  def change
    create_table :contact_details do |t|
      t.integer :detail_field_id
      t.string :detail_type
      t.string :detail_value

      t.integer :contact_id

      t.timestamps
    end
  end
end
