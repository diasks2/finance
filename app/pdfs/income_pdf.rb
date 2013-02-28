# -*- encoding : utf-8 -*-
class IncomePdf < Prawn::Document
  include ActionView::Helpers::NumberHelper
 
  def initialize(date1, date2, revenues, revenues_sum, expenses, expenses_sum)
  	super(top_margin: 70)
  	@date1 = date1
    @date2 = date2
    @revenues = revenues
    @revenues_sum = revenues_sum
    @expenses = expenses
    @expenses_sum = expenses_sum
   	text "Income Statement (¥)", size: 20, style: :bold, :align => :center 
   	text "For the period from #{@date1.to_date.to_s(:long)} to #{@date2.to_date.to_s(:long)}", size: 16, style: :bold, :align => :center 
   	move_down 20
   	line_items
  end

  def line_items
    table rev_line_item_rows do
      row(0).font_style = :bold
      cells.style(:border_width => 0)
      columns(1..2).align = :right
      columns(0).width = 350
      columns(1..2).width = 90
    end
    table rev_line_item_rows2 do
      row(0).font_style = :bold
      cells.style(:border_width => 0)
      columns(1..2).align = :right
      columns(0).width = 350
      column(2).style(:text_color => "6dba34")
      columns(1..2).width = 90
    end
    move_down 10
    table ex_line_item_rows do
      row(0).font_style = :bold
      cells.style(:border_width => 0)
      columns(1..2).align = :right
      columns(0).width = 350
      columns(1..2).width = 90
    end
    table ex_line_item_rows2 do
      row(0).font_style = :bold
      cells.style(:border_width => 0)
      columns(1..2).align = :right
      columns(0).width = 350
      column(1).style(:text_color => "db1629") 
      columns(1..2).width = 90
    end
    if @revenues_sum.abs - @expenses_sum > 0
	    table net_income do
	      row(0).font_style = :bold
	      cells.style(:border_width => 0)
	      column(2).style(:text_color => "6dba34")
	      columns(1..2).align = :right
	      columns(0).width = 350
	      columns(1..2).width = 90
	    end
	else
		table net_income do
	      row(0).font_style = :bold
	      cells.style(:border_width => 0)
	      column(2).style(:text_color => "db1629") 
	      columns(1..2).align = :right
	      columns(0).width = 350
	      columns(1..2).width = 90
	    end   
	end
  end

  def rev_line_item_rows
    [["Revenues", "Debit (¥)", "Credit (¥)"]] +
    @revenues.map do |r|
      [r[0], "", number_to_currency(r[1].abs, :unit => "¥", :precision => 0)]
    end
  end

  def rev_line_item_rows2
    [["Total Revenue", "", number_to_currency(@revenues_sum.abs, :unit => "¥", :precision => 0)]]
  end

  def ex_line_item_rows
    [["Expenses", "", ""]] +
    @expenses.map do |e|
      [e[0], number_to_currency(e[1].abs, :unit => "¥", :precision => 0),""]
    end
  end

  def ex_line_item_rows2
    [["Total Expense", number_to_currency(@expenses_sum, :unit => "¥", :precision => 0), ""]]
  end

  def net_income
    [["Net Income", "", number_to_currency(@revenues_sum.abs - @expenses_sum, :unit => "¥", :precision => 0)]]
  end

 

end