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
    Transaction.includes(:category, :group, :account).where("amount < ?", 0).where("currency = ?", "JPY").where("accounts.internal = ?", true).sum("amount")
  end

  def dollar_assets
    Transaction.includes(:category, :group, :account).where("amount < ?", 0).where("currency = ?", "USD").where("accounts.internal = ?", true).sum("amount").to_d / 100
  end

  def converted_assets
    (Transaction.includes(:category, :group, :account).where("amount < ?", 0).where("currency = ?", "USD").where("accounts.internal = ?", true).sum("amount").to_d / 100 * rate) + Transaction.includes(:category, :group, :account).where("amount < ?", 0).where("currency = ?", "JPY").where("accounts.internal = ?", true).sum("amount")
  end
end
