# -*- encoding : utf-8 -*-
class AddLiquidToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :liquid, :boolean, :default => false
  end
end
