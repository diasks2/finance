# -*- encoding : utf-8 -*-
module AccountsHelper
  def yen_balance(account_id)
  	Transaction.where("account_id = ?", account_id).where("currency = ?", "JPY").sum("amount")
  end	

  def dollar_balance(account_id)
  	Transaction.where("account_id = ?", account_id).where("currency = ?", "USD").sum("amount").to_d / 100
  end	

  def yen_balance_zero
  	Transaction.where("currency = ?", "JPY").sum("amount")
  end	

  def dollar_balance_zero
  	Transaction.where("currency = ?", "USD").sum("amount").to_d / 100
  end
end
