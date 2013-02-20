# -*- encoding : utf-8 -*-
class RemoveCategoryIdFromAccounts < ActiveRecord::Migration
  def change
    remove_column :accounts, :category_id
  end
end
