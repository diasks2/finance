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

  def yen_assets
    unless Account.group("accounts.id").includes(:transactions).where("internal = ?", true).where("currency = ?", "JPY").having("sum(transactions.amount) < ?", 0).sum("transactions.amount").values.inject{|sum,x| sum + x } == nil
      Account.group("accounts.id").includes(:transactions).where("internal = ?", true).where("currency = ?", "JPY").having("sum(transactions.amount) < ?", 0).sum("transactions.amount").values.inject{|sum,x| sum + x }.to_d
    else
      0
    end 
  end

  def dollar_assets
    unless Account.group("accounts.id").includes(:transactions).where("internal = ?", true).where("currency = ?", "USD").having("sum(transactions.amount) < ?", 0).sum("transactions.amount").values.inject{|sum,x| sum + x } == nil
      Account.group("accounts.id").includes(:transactions).where("internal = ?", true).where("currency = ?", "USD").having("sum(transactions.amount) < ?", 0).sum("transactions.amount").values.inject{|sum,x| sum + x }.to_d / 100
    else
      0
    end 
  end

  def converted_assets
    (dollar_assets * rate) + yen_assets
  end

  def liquid_yen_assets
    unless Account.group("accounts.id").includes(:transactions).where("internal = ?", true).where("currency = ?", "JPY").where("liquid = ?", true).having("sum(transactions.amount) < ?", 0).sum("transactions.amount").values.inject{|sum,x| sum + x } == nil
      Account.group("accounts.id").includes(:transactions).where("internal = ?", true).where("currency = ?", "JPY").where("liquid = ?", true).having("sum(transactions.amount) < ?", 0).sum("transactions.amount").values.inject{|sum,x| sum + x }.to_d
    else
      0
    end  
  end

  def liquid_dollar_assets
    unless Account.group("accounts.id").includes(:transactions).where("internal = ?", true).where("currency = ?", "USD").where("liquid = ?", true).having("sum(transactions.amount) < ?", 0).sum("transactions.amount").values.inject{|sum,x| sum + x }.to_d == nil
      Account.group("accounts.id").includes(:transactions).where("internal = ?", true).where("currency = ?", "USD").where("liquid = ?", true).having("sum(transactions.amount) < ?", 0).sum("transactions.amount").values.inject{|sum,x| sum + x }.to_d / 100
    else
      0
    end  
  end

  def liquid_converted_assets
    (liquid_dollar_assets * rate) + liquid_yen_assets
  end

  def illiquid_yen_assets
    unless Account.group("accounts.id").includes(:transactions).where("internal = ?", true).where("currency = ?", "JPY").where("liquid = ?", false).having("sum(transactions.amount) < ?", 0).sum("transactions.amount").values.inject{|sum,x| sum + x } == nil
      Account.group("accounts.id").includes(:transactions).where("internal = ?", true).where("currency = ?", "JPY").where("liquid = ?", false).having("sum(transactions.amount) < ?", 0).sum("transactions.amount").values.inject{|sum,x| sum + x }.to_d
    else
      0
    end  
  end

  def illiquid_dollar_assets
    unless Account.group("accounts.id").includes(:transactions).where("internal = ?", true).where("currency = ?", "USD").where("liquid = ?", false).having("sum(transactions.amount) < ?", 0).sum("transactions.amount").values.inject{|sum,x| sum + x }.to_d == nil
      Account.group("accounts.id").includes(:transactions).where("internal = ?", true).where("currency = ?", "USD").where("liquid = ?", false).having("sum(transactions.amount) < ?", 0).sum("transactions.amount").values.inject{|sum,x| sum + x }.to_d / 100
    else
      0
    end  
  end

  def illiquid_converted_assets
    (illiquid_dollar_assets * rate) + illiquid_yen_assets
  end

  def yen_liabilities
    unless Account.group("accounts.id").includes(:transactions).where("internal = ?", true).where("currency = ?", "JPY").having("sum(transactions.amount) > ?", 0).sum("transactions.amount").values.inject{|sum,x| sum + x } == nil
      Account.group("accounts.id").includes(:transactions).where("internal = ?", true).where("currency = ?", "JPY").having("sum(transactions.amount) > ?", 0).sum("transactions.amount").values.inject{|sum,x| sum + x }.to_d
    else
      0
    end 
  end

  def dollar_liabilities
    unless Account.group("accounts.id").includes(:transactions).where("internal = ?", true).where("currency = ?", "USD").having("sum(transactions.amount) > ?", 0).sum("transactions.amount").values.inject{|sum,x| sum + x } == nil
      Account.group("accounts.id").includes(:transactions).where("internal = ?", true).where("currency = ?", "USD").having("sum(transactions.amount) > ?", 0).sum("transactions.amount").values.inject{|sum,x| sum + x }.to_d / 100
    else
      0
    end 
  end

  def converted_liabilities
    (dollar_liabilities * rate) + yen_liabilities
  end

  def st_yen_liabilities
    unless Account.group("accounts.id").includes(:transactions).where("internal = ?", true).where("currency = ?", "JPY").where("liquid = ?", true).having("sum(transactions.amount) > ?", 0).sum("transactions.amount").values.inject{|sum,x| sum + x } == nil
      Account.group("accounts.id").includes(:transactions).where("internal = ?", true).where("currency = ?", "JPY").where("liquid = ?", true).having("sum(transactions.amount) > ?", 0).sum("transactions.amount").values.inject{|sum,x| sum + x }.to_d
    else
      0
    end  
  end

  def st_dollar_liabilities
    unless Account.group("accounts.id").includes(:transactions).where("internal = ?", true).where("currency = ?", "USD").where("liquid = ?", true).having("sum(transactions.amount) > ?", 0).sum("transactions.amount").values.inject{|sum,x| sum + x }.to_d == nil
      Account.group("accounts.id").includes(:transactions).where("internal = ?", true).where("currency = ?", "USD").where("liquid = ?", true).having("sum(transactions.amount) > ?", 0).sum("transactions.amount").values.inject{|sum,x| sum + x }.to_d / 100
    else
      0
    end  
  end

  def st_converted_liabilities
    (st_dollar_liabilities * rate) + st_yen_liabilities
  end

  def lt_yen_liabilities
    unless Account.group("accounts.id").includes(:transactions).where("internal = ?", true).where("currency = ?", "JPY").where("liquid = ?", false).having("sum(transactions.amount) > ?", 0).sum("transactions.amount").values.inject{|sum,x| sum + x } == nil
      Account.group("accounts.id").includes(:transactions).where("internal = ?", true).where("currency = ?", "JPY").where("liquid = ?", false).having("sum(transactions.amount) > ?", 0).sum("transactions.amount").values.inject{|sum,x| sum + x }.to_d
    else
      0
    end  
  end

  def lt_dollar_liabilities
    unless Account.group("accounts.id").includes(:transactions).where("internal = ?", true).where("currency = ?", "USD").where("liquid = ?", false).having("sum(transactions.amount) > ?", 0).sum("transactions.amount").values.inject{|sum,x| sum + x }.to_d == nil
      Account.group("accounts.id").includes(:transactions).where("internal = ?", true).where("currency = ?", "USD").where("liquid = ?", false).having("sum(transactions.amount) > ?", 0).sum("transactions.amount").values.inject{|sum,x| sum + x }.to_d / 100
    else
      0
    end  
  end

  def lt_converted_liabilities
    (lt_dollar_liabilities * rate) + lt_yen_liabilities
  end

  def equity_yen
    yen_assets + yen_liabilities
  end

  def equity_dollar
    dollar_assets + dollar_liabilities
  end

  def equity_converted
    converted_assets + converted_liabilities
  end
end
