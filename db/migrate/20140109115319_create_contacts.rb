class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :prefix
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.string :suffix
      t.string :organization
      t.boolean :is_organization

      t.timestamps
    end
  end
end
