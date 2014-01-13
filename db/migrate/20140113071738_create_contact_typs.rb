class CreateContactTyps < ActiveRecord::Migration
  def change
    create_table :contact_typs do |t|
      t.string :name

      t.timestamps
    end
  end
end
