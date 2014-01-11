class CreateContactDetails < ActiveRecord::Migration
  def change
    create_table :contact_details do |t|
      t.string :detail_field
      t.string :detail_type
      t.string :detail_value

      t.integer :contact_id

      t.timestamps
    end
  end
end
