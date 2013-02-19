class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :account_id
      t.date :date
      t.integer :amount
      t.string :currency
      t.string :unique_hash
      
      t.timestamps
    end
  end
end
