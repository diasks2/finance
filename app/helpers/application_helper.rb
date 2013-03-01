# -*- encoding : utf-8 -*-
module ApplicationHelper
  def markdown(text)
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(
        :hard_wrap => true, :filter_html => true, :safe_links_only => true),
        :no_intra_emphasis => true, :autolink => true, :strikethrough => true, :superscript => true)
    return markdown.render(text).html_safe
  end

  def full_title(page_title)
    base_title = "Personal Finance App"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def string_rate
    rate = Rate.last
    "%.2f" % rate.rate
  end

  def rate
    rate = Rate.last
    rate.rate
  end

  def yen_assets(date)
    unless Account.group("accounts.id").includes(:transactions).where("internal = ?", true).where("currency = ?", "JPY").where("transactions.date <= ?", date).having("sum(transactions.amount) < ?", 0).sum("transactions.amount").values.inject{|sum,x| sum + x } == nil
      Account.group("accounts.id").includes(:transactions).where("internal = ?", true).where("currency = ?", "JPY").where("transactions.date <= ?", date).having("sum(transactions.amount) < ?", 0).sum("transactions.amount").values.inject{|sum,x| sum + x }.to_d
    else
      0
    end 
  end

  def dollar_assets(date)
    unless Account.group("accounts.id").includes(:transactions).where("internal = ?", true).where("currency = ?", "USD").where("transactions.date <= ?", date).having("sum(transactions.amount) < ?", 0).sum("transactions.amount").values.inject{|sum,x| sum + x } == nil
      Account.group("accounts.id").includes(:transactions).where("internal = ?", true).where("currency = ?", "USD").where("transactions.date <= ?", date).having("sum(transactions.amount) < ?", 0).sum("transactions.amount").values.inject{|sum,x| sum + x }.to_d / 100
    else
      0
    end 
  end

  def converted_assets(date)
    (dollar_assets(date) * rate) + yen_assets(date)
  end

  def liquid_yen_assets(date)
    unless Account.group("accounts.id").includes(:transactions).where("internal = ?", true).where("currency = ?", "JPY").where("liquid = ?", true).where("transactions.date <= ?", date).having("sum(transactions.amount) < ?", 0).sum("transactions.amount").values.inject{|sum,x| sum + x } == nil
      Account.group("accounts.id").includes(:transactions).where("internal = ?", true).where("currency = ?", "JPY").where("liquid = ?", true).where("transactions.date <= ?", date).having("sum(transactions.amount) < ?", 0).sum("transactions.amount").values.inject{|sum,x| sum + x }.to_d
    else
      0
    end  
  end

  def liquid_dollar_assets(date)
    unless Account.group("accounts.id").includes(:transactions).where("internal = ?", true).where("currency = ?", "USD").where("liquid = ?", true).where("transactions.date <= ?", date).having("sum(transactions.amount) < ?", 0).sum("transactions.amount").values.inject{|sum,x| sum + x } == nil
      Account.group("accounts.id").includes(:transactions).where("internal = ?", true).where("currency = ?", "USD").where("liquid = ?", true).where("transactions.date <= ?", date).having("sum(transactions.amount) < ?", 0).sum("transactions.amount").values.inject{|sum,x| sum + x }.to_d / 100
    else
      0
    end  
  end

  def liquid_converted_assets(date)
    (liquid_dollar_assets(date) * rate) + liquid_yen_assets(date)
  end

  def illiquid_yen_assets(date)
    unless Account.group("accounts.id").includes(:transactions).where("internal = ?", true).where("currency = ?", "JPY").where("liquid = ?", false).where("transactions.date <= ?", date).having("sum(transactions.amount) < ?", 0).sum("transactions.amount").values.inject{|sum,x| sum + x } == nil
      Account.group("accounts.id").includes(:transactions).where("internal = ?", true).where("currency = ?", "JPY").where("liquid = ?", false).where("transactions.date <= ?", date).having("sum(transactions.amount) < ?", 0).sum("transactions.amount").values.inject{|sum,x| sum + x }.to_d
    else
      0
    end  
  end

  def illiquid_dollar_assets(date)
    unless Account.group("accounts.id").includes(:transactions).where("internal = ?", true).where("currency = ?", "USD").where("liquid = ?", false).where("transactions.date <= ?", date).having("sum(transactions.amount) < ?", 0).sum("transactions.amount").values.inject{|sum,x| sum + x } == nil
      Account.group("accounts.id").includes(:transactions).where("internal = ?", true).where("currency = ?", "USD").where("liquid = ?", false).where("transactions.date <= ?", date).having("sum(transactions.amount) < ?", 0).sum("transactions.amount").values.inject{|sum,x| sum + x }.to_d / 100
    else
      0
    end  
  end

  def illiquid_converted_assets(date)
    (illiquid_dollar_assets(date) * rate) + illiquid_yen_assets(date)
  end

  def yen_liabilities(date)
    unless Account.group("accounts.id").includes(:transactions).where("internal = ?", true).where("currency = ?", "JPY").where("transactions.date <= ?", date).having("sum(transactions.amount) > ?", 0).sum("transactions.amount").values.inject{|sum,x| sum + x } == nil
      Account.group("accounts.id").includes(:transactions).where("internal = ?", true).where("currency = ?", "JPY").where("transactions.date <= ?", date).having("sum(transactions.amount) > ?", 0).sum("transactions.amount").values.inject{|sum,x| sum + x }.to_d
    else
      0
    end 
  end

  def dollar_liabilities(date)
    unless Account.group("accounts.id").includes(:transactions).where("internal = ?", true).where("currency = ?", "USD").where("transactions.date <= ?", date).having("sum(transactions.amount) > ?", 0).sum("transactions.amount").values.inject{|sum,x| sum + x } == nil
      Account.group("accounts.id").includes(:transactions).where("internal = ?", true).where("currency = ?", "USD").where("transactions.date <= ?", date).having("sum(transactions.amount) > ?", 0).sum("transactions.amount").values.inject{|sum,x| sum + x }.to_d / 100
    else
      0
    end 
  end

  def converted_liabilities(date)
    (dollar_liabilities(date) * rate) + yen_liabilities(date)
  end

  def st_yen_liabilities(date)
    unless Account.group("accounts.id").includes(:transactions).where("internal = ?", true).where("currency = ?", "JPY").where("liquid = ?", true).where("transactions.date <= ?", date).having("sum(transactions.amount) > ?", 0).sum("transactions.amount").values.inject{|sum,x| sum + x } == nil
      Account.group("accounts.id").includes(:transactions).where("internal = ?", true).where("currency = ?", "JPY").where("liquid = ?", true).where("transactions.date <= ?", date).having("sum(transactions.amount) > ?", 0).sum("transactions.amount").values.inject{|sum,x| sum + x }.to_d
    else
      0
    end  
  end

  def st_dollar_liabilities(date)
    unless Account.group("accounts.id").includes(:transactions).where("internal = ?", true).where("currency = ?", "USD").where("liquid = ?", true).where("transactions.date <= ?", date).having("sum(transactions.amount) > ?", 0).sum("transactions.amount").values.inject{|sum,x| sum + x } == nil
      Account.group("accounts.id").includes(:transactions).where("internal = ?", true).where("currency = ?", "USD").where("liquid = ?", true).where("transactions.date <= ?", date).having("sum(transactions.amount) > ?", 0).sum("transactions.amount").values.inject{|sum,x| sum + x }.to_d / 100
    else
      0
    end  
  end

  def st_converted_liabilities(date)
    (st_dollar_liabilities(date) * rate) + st_yen_liabilities(date)
  end

  def lt_yen_liabilities(date)
    unless Account.group("accounts.id").includes(:transactions).where("internal = ?", true).where("currency = ?", "JPY").where("liquid = ?", false).where("transactions.date <= ?", date).having("sum(transactions.amount) > ?", 0).sum("transactions.amount").values.inject{|sum,x| sum + x } == nil
      Account.group("accounts.id").includes(:transactions).where("internal = ?", true).where("currency = ?", "JPY").where("liquid = ?", false).where("transactions.date <= ?", date).having("sum(transactions.amount) > ?", 0).sum("transactions.amount").values.inject{|sum,x| sum + x }.to_d
    else
      0
    end  
  end

  def lt_dollar_liabilities(date)
    unless Account.group("accounts.id").includes(:transactions).where("internal = ?", true).where("currency = ?", "USD").where("liquid = ?", false).where("transactions.date <= ?", date).having("sum(transactions.amount) > ?", 0).sum("transactions.amount").values.inject{|sum,x| sum + x } == nil
      Account.group("accounts.id").includes(:transactions).where("internal = ?", true).where("currency = ?", "USD").where("liquid = ?", false).where("transactions.date <= ?", date).having("sum(transactions.amount) > ?", 0).sum("transactions.amount").values.inject{|sum,x| sum + x }.to_d / 100
    else
      0
    end  
  end

  def lt_converted_liabilities(date)
    (lt_dollar_liabilities(date) * rate) + lt_yen_liabilities(date)
  end

  def equity_yen(date)
    yen_assets(date) + yen_liabilities(date)
  end

  def equity_dollar(date)
    dollar_assets(date) + dollar_liabilities(date)
  end

  def equity_converted(date)
    converted_assets(date) + converted_liabilities(date)
  end

end
