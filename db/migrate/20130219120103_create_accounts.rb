class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :name
      t.string :owner
      t.integer :category_id
      t.string :phone_number
      t.text :address
      t.string :url

      t.timestamps
    end
  end
end
