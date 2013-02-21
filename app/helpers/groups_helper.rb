module GroupsHelper
  def group_yen_total(group_id)
  	Transaction.includes(:category, :group).where("amount > ?", 0).where("currency = ?", "JPY").where("groups.id = ?", group_id).sum("amount")
  end
  def group_dollar_total(group_id)
  	Transaction.includes(:category, :group).where("amount > ?", 0).where("currency = ?", "USD").where("groups.id = ?", group_id).sum("amount").to_d / 100
  end
  def group_converted_total(group_id)
  	Transaction.includes(:category, :group).where("amount > ?", 0).where("currency = ?", "JPY").where("groups.id = ?", group_id).sum("amount") + (Transaction.includes(:category, :group).where("amount > ?", 0).where("currency = ?", "USD").where("groups.id = ?", group_id).sum("amount").to_d / 100 * rate)
  end
end