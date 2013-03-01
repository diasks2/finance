# -*- encoding : utf-8 -*-
class TransactionsController < ApplicationController
  
  def new
    @transaction = Transaction.new
  end

  def create
    @transaction_a = Transaction.new(params[:transaction_a])
    @transaction_b = Transaction.new(params[:transaction_b])
    
		# create hash string for both records
  	o = [('a'..'z'),('A'..'Z')].map{|i| i.to_a}.flatten
  	string = (0...50).map{ o[rand(o.length)] }.join
  	@transaction_a.update_attribute :unique_hash, string
  	@transaction_b.update_attribute :unique_hash, string
    
    date = params[:transaction][:date]
    currency = params[:transaction][:currency]
    category = params[:transaction][:category_id]
    @transaction_a.update_attribute :date, date
    @transaction_b.update_attribute :date, date
    @transaction_a.update_attribute :currency, currency
    @transaction_b.update_attribute :currency, currency
    @transaction_a.update_attribute :category_id, category
    @transaction_b.update_attribute :category_id, category
	    
    if @transaction_a.converted_amount + @transaction_b.converted_amount == 0 && @transaction_a.date == @transaction_b.date && @transaction_a.currency == @transaction_b.currency
	    if @transaction_a.save && @transaction_b.save
	      redirect_to transactions_path, notice: "New Transaction Successfully Created."
	    else
	      render :new
	    end
	  else
        redirect_to new_transaction_path, :flash => { :error => "Transactions Do Not Balance." }
    end    

  end

  def update
    @transaction = Transaction.find(params[:id])
    if @transaction.update_attributes(params[:transaction])
      redirect_to @transaction, notice: "Transaction Successfully Updated."
    else
      render 'edit'
    end
  end

  def show
    @transaction = Transaction.find(params[:id])
  end

  def index
    @transactions = Transaction.order("date").all
    respond_to do |format|
      format.html
      format.json{
        render :json => @transactions.to_json
      }
      format.csv { send_data Transaction.to_csv, :filename => "Finance_transactions_#{Time.now.to_date.to_s}.csv" }
      format.xls { headers["Content-Disposition"] = "attachment; filename=\"Finance_transactions_#{Time.now.to_date.to_s}.xls\"" }
    end
  end

  def destroy
    @transaction = Transaction.find(params[:id])
    @transaction.destroy
      redirect_to transactions_path, notice: "Transaction Successfully Destroyed."
  end

end
