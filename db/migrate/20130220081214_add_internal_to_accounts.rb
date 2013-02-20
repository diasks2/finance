class AddInternalToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :internal, :boolean, :default => false
  end
end
