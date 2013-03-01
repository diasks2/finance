# -*- encoding : utf-8 -*-
class BalancePdf < Prawn::Document
  include ActionView::Helpers::NumberHelper
  include ApplicationHelper

   def initialize(date)
  	super(top_margin: 70)
  	@date = date
   	text "Balance Sheet", size: 20, style: :bold, :align => :center 
   	text "#{Date.today.to_s(:long)}", size: 16, style: :bold, :align => :center 
   	move_down 20
   	line_items
   	move_down 50
   	text "Balance Sheet (Converted)", size: 20, style: :bold, :align => :center
   	text "#{Date.today.to_s(:long)}", size: 16, style: :bold, :align => :center  
   	move_down 20
   	line_items_yen
  end

  def line_items
    table bal_line_item_rows do
      row(0).font_style = :bold
      row(3..6).font_style = :bold
      cells.style(:border_width => 0, size: 10)
      columns(1..2).align = :right
      columns(5..6).align = :right
      columns(3).width = 35
      columns(0).width = 70
      columns(4).width = 170
      columns(1..2).width = 65
      columns(5..6).width = 65
    end
  end 
  
  def line_items_yen 
    table yen_bal_line_item_rows do
      row(0).font_style = :bold
      row(2..5).font_style = :bold
      cells.style(:border_width => 0, size: 10)
      columns(1).align = :right
      columns(5).align = :right
      columns(2).width = 35
      columns(0).width = 135
      columns(3).width = 170
      columns(1).width = 65
      columns(5).width = 65
    end
  end  
  
  
  def bal_line_item_rows
    [["Assets", "", "", "", "Liabilities and Owner's Equity", "", ""]] +
    [["Liquid", "#{number_to_currency(0 - liquid_yen_assets(@date), :unit => "¥", :precision => 0)}", "#{number_to_currency(0 - liquid_dollar_assets(@date))}", "", "Short-term Liabilities", "#{number_to_currency(st_yen_liabilities(@date), :unit => "¥", :precision => 0)}", "#{number_to_currency(st_dollar_liabilities(@date))}"]] +
    [["Illiquid", "#{number_to_currency(0 - illiquid_yen_assets(@date), :unit => "¥", :precision => 0)}", "#{number_to_currency(0 - illiquid_dollar_assets(@date))}", "", "Long-term Liabilities", "#{number_to_currency(lt_yen_liabilities(@date), :unit => "¥", :precision => 0)}", "#{number_to_currency(lt_dollar_liabilities(@date))}"]] +
    [["Total Assets", "#{number_to_currency(0 - yen_assets(@date), :unit => "¥", :precision => 0)}", "#{number_to_currency(0 - dollar_assets(@date))}", "", "Total Liabilities", "#{number_to_currency(yen_liabilities(@date), :unit => "¥", :precision => 0) }", "#{number_to_currency(dollar_liabilities(@date))}"]] +
    [["", "", "", "", "Total Owner's Equity", "#{number_to_currency(0 - equity_yen(@date), :unit => "¥", :precision => 0)}", "#{number_to_currency(0 - equity_dollar(@date))}"]] +
    [["Total", "#{number_to_currency(0 - yen_assets(@date), :unit => "¥", :precision => 0)}", "#{number_to_currency(0 - dollar_assets(@date))}", "", "Total", "#{number_to_currency(yen_liabilities(@date) - equity_yen(@date), :unit => "¥", :precision => 0)}", "#{number_to_currency(dollar_liabilities(@date) - equity_dollar(@date))}"]]
  end  

  def yen_bal_line_item_rows
    [["Assets", "", "", "Liabilities and Owner's Equity", ""]] +
    [["Liquid", "#{number_to_currency(0 - liquid_converted_assets(@date), :unit => "¥", :precision => 0)}", "", "Short-term Liabilities", "#{number_to_currency(st_converted_liabilities(@date), :unit => "¥", :precision => 0)}"]] +
    [["Illiquid", "#{number_to_currency(0 - illiquid_converted_assets(@date), :unit => "¥", :precision => 0)}", "", "Long-term Liabilities", "#{number_to_currency(lt_converted_liabilities(@date), :unit => "¥", :precision => 0)}"]] +
    [["Total Assets", "#{number_to_currency(0 - converted_assets(@date), :unit => "¥", :precision => 0)}", "", "Total Liabilities", "#{number_to_currency(converted_liabilities(@date), :unit => "¥", :precision => 0)}"]] +
    [["", "", "", "Total Owner's Equity", "#{number_to_currency(0 - equity_converted(@date), :unit => "¥", :precision => 0)}"]] +
    [["Total", "#{number_to_currency(0 - converted_assets(@date), :unit => "¥", :precision => 0)}", "", "Total", "#{number_to_currency(converted_liabilities(@date) - equity_converted(@date), :unit => "¥", :precision => 0)}"]]
  end  
end