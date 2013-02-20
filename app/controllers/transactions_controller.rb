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
    @transaction_a.update_attribute :date, date
    @transaction_b.update_attribute :date, date
    @transaction_a.update_attribute :currency, currency
    @transaction_b.update_attribute :currency, currency
	    
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

  def edit
    @transaction = Transaction.find(params[:id])
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
    @transactions = Transaction.order("id").all
  end

  def destroy
    @transaction = Transaction.find(params[:id])
    @transaction.destroy
      redirect_to transactions_path, notice: "Transaction Successfully Destroyed."
  end

end
