# -*- encoding : utf-8 -*-
class StaticPagesController < ApplicationController
  def home
    @groups = Group.where("id != ?", 21).order("name").all
    @categories = Category.where("id != ?", 65).order("group_id").order("name").all
  end

  def balance
    if params.has_key?(:bsdate)
      year = params[:bsdate][0...4].to_d
      month = params[:bsdate][5...7].to_d
      day = params[:bsdate][8...10].to_d
      @date = Date.new(year,month,day)
    else  
      @date = Date.today
    end 

    respond_to do |format|
      format.html
      format.js
      format.pdf do
        pdf = BalancePdf.new(@date)
        send_data pdf.render, filename: "Balance Sheet #{Date.today}",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end

  def income
    ratearray = Rate.last
    rate = ratearray.rate

    if (params.has_key?(:date1) && params.has_key?(:date2))
      year1 = params[:date1][0...4].to_d
      month1 = params[:date1][5...7].to_d
      day1 = params[:date1][8...10].to_d
      year2 = params[:date2][0...4].to_d
      month2 = params[:date2][5...7].to_d
      day2 = params[:date2][8...10].to_d
      @date1 = Date.new(year1,month1,day1)
      @date2 = Date.new(year2,month2,day2)
    else  
      @date1 = Date.today - 1.month
      @date2 = Date.today
    end  
   
    usd_revenues = Transaction.includes(:category, :group).where("groups.id = ?", 1).where("date > ?", @date1).where("date < ?", @date2).where("amount < ?", 0).where("currency = ?", "USD").group("categories.name").sum("amount")
    yen_revenues = Transaction.includes(:category, :group).where("groups.id = ?", 1).where("date > ?", @date1).where("date < ?", @date2).where("amount < ?", 0).where("currency = ?", "JPY").group("categories.name").sum("amount")
    dollar_revenues = usd_revenues.inject({}) { |h, (k, v)| h[k] = v.to_d / 100 * rate; h }

    @revenues = dollar_revenues.merge(yen_revenues) {|key,val1,val2| val1+val2}.sort_by{|k,v| v}
    
    revenue_array = []
    @revenues.each do |r|
      revenue_array << r[1]
    end
    unless revenue_array.any?
      @revenues_sum = 0
    else
      @revenues_sum = revenue_array.inject{|sum,x| sum + x }
    end  

    usd_expenses = Transaction.includes(:category, :group).where("groups.id != ?", 1).where("date > ?", @date1).where("date < ?", @date2).where("groups.id != ?", 21).where("amount > ?", 0).where("currency = ?", "USD").group("categories.name").sum("amount")
    yen_expenses = Transaction.includes(:category, :group).where("groups.id != ?", 1).where("date > ?", @date1).where("date < ?", @date2).where("groups.id != ?", 21).where("amount > ?", 0).where("currency = ?", "JPY").group("categories.name").sum("amount")
    dollar_expenses = usd_expenses.inject({}) { |h, (k, v)| h[k] = v.to_d / 100 * rate; h }

    @expenses = dollar_expenses.merge(yen_expenses) {|key,val1,val2| val1+val2}.sort_by{|k,v| v}.reverse
    
    expense_array = []
    @expenses.each do |e|
      expense_array << e[1]
    end
    unless expense_array.any?
      @expenses_sum = 0
    else
      @expenses_sum = expense_array.inject{|sum,x| sum + x }
    end  

    respond_to do |format|
      format.html
      format.js
      format.pdf do
        pdf = IncomePdf.new(@date1, @date2, @revenues, @revenues_sum, @expenses, @expenses_sum)
        send_data pdf.render, filename: "Income Statement #{@date1} to #{@date2}",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
      
  end

  def graph1
    @transactions = Transaction.includes(:category, :group).where("amount > ?", 0).where("groups.id != ?", 1).where("groups.id != ?", 21).group("categories.name").sum("amount")
    respond_to do |format|
      format.json {
        render :json => custom_json_for(@transactions)
      }
    end
  end

  def graph2
    @transactions = Transaction.includes(:category, :group).where("amount > ?", 0).where("groups.id != ?", 1).where("groups.id != ?", 21).group("groups.name").sum("amount")
    respond_to do |format|
      format.json do
        render :json => custom_json_for(@transactions)
      end
    end
  end

  def networth
    ratearray = Rate.last
    rate = ratearray.rate

    start = Date.new(2013,2,14)
    finish = Date.today
    dates = (start..finish).map{ |date| date } 

    @networths = Hash.new
    dates.each do |date|
      #dollar_assets
      if Account.group("accounts.id").includes(:transactions).where("internal = ?", true).where("transactions.date <= ?", date).where("currency = ?", "USD").having("sum(transactions.amount) < ?", 0).sum("transactions.amount").values.inject{|sum,x| sum + x } == nil
        dollar_assets = 0
      else
        dollar_assets = Account.group("accounts.id").includes(:transactions).where("internal = ?", true).where("transactions.date <= ?", date).where("currency = ?", "USD").having("sum(transactions.amount) < ?", 0).sum("transactions.amount").values.inject{|sum,x| sum + x }.to_d / 100 * rate 
      end  

      #yen_assets
      if Account.group("accounts.id").includes(:transactions).where("internal = ?", true).where("transactions.date <= ?", date).where("currency = ?", "JPY").having("sum(transactions.amount) < ?", 0).sum("transactions.amount").values.inject{|sum,x| sum + x } == nil
        yen_assets = 0
      else
        yen_assets = Account.group("accounts.id").includes(:transactions).where("internal = ?", true).where("transactions.date <= ?", date).where("currency = ?", "JPY").having("sum(transactions.amount) < ?", 0).sum("transactions.amount").values.inject{|sum,x| sum + x }  
      end

      #dollar_liabilities
      if Account.group("accounts.id").includes(:transactions).where("internal = ?", true).where("transactions.date <= ?", date).where("currency = ?", "USD").having("sum(transactions.amount) > ?", 0).sum("transactions.amount").values.inject{|sum,x| sum + x } == nil
        dollar_liabilities = 0
      else
        dollar_liabilities = Account.group("accounts.id").includes(:transactions).where("internal = ?", true).where("transactions.date <= ?", date).where("currency = ?", "USD").having("sum(transactions.amount) > ?", 0).sum("transactions.amount").values.inject{|sum,x| sum + x }.to_d / 100 * rate
      end 

      #yen_liabilities
      if Account.group("accounts.id").includes(:transactions).where("internal = ?", true).where("transactions.date <= ?", date).where("currency = ?", "JPY").having("sum(transactions.amount) > ?", 0).sum("transactions.amount").values.inject{|sum,x| sum + x } == nil
        yen_liabilities = 0
      else  
        yen_liabilities = Account.group("accounts.id").includes(:transactions).where("internal = ?", true).where("transactions.date <= ?", date).where("currency = ?", "JPY").having("sum(transactions.amount) > ?", 0).sum("transactions.amount").values.inject{|sum,x| sum + x }.to_d
      end 

      @networths[date] = ((dollar_assets + yen_assets) + (dollar_liabilities + yen_liabilities)).abs
    end
    respond_to do |format|
      format.json do
        render :json => custom_json_for_networth(@networths)
      end
    end
  end  
  
    
private
  def custom_json_for(value)
    list = value.map do |k, v|
      { :name => k,
        :amount => v    
      }
    end
    list.to_json
  end

  def custom_json_for_networth(value)
    list = value.map do |k, v|
      { :date => k.strftime("%d-%b-%y"),
        :networth => v    
      }
    end
    list.to_json
  end

end
