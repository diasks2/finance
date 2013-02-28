# -*- encoding : utf-8 -*-
module CategoriesHelper
  def category_yen_total(category_id)
  	Transaction.includes(:category, :group).where("amount > ?", 0).where("currency = ?", "JPY").where("category_id = ?", category_id).sum("amount")
  end
  def category_dollar_total(category_id)
  	Transaction.includes(:category, :group).where("amount > ?", 0).where("currency = ?", "USD").where("category_id = ?", category_id).sum("amount").to_d / 100
  end
  def category_converted_total(category_id)
  	Transaction.includes(:category, :group).where("amount > ?", 0).where("currency = ?", "JPY").where("category_id = ?", category_id).sum("amount") + (Transaction.includes(:category, :group).where("amount > ?", 0).where("currency = ?", "USD").where("category_id = ?", category_id).sum("amount").to_d / 100 * rate)
  end
end
