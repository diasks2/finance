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
end
