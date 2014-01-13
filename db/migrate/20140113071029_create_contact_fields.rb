class CreateContactFields < ActiveRecord::Migration
  def change
    create_table :contact_fields do |t|
      t.string :name

      t.timestamps
    end
  end
end
