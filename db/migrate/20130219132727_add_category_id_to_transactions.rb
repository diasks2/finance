# -*- encoding : utf-8 -*-
class AddCategoryIdToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :category_id, :integer
  end
end
