class CreateRates < ActiveRecord::Migration
  def change
    create_table :rates do |t|
      t.string :currency
      t.decimal :rate

      t.timestamps
    end
  end
end
