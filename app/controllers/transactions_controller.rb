class TransactionsController < ApplicationController
  
  def new
    @transaction = Transaction.new
  end

  def create
    @transaction_a = Transaction.new(params[:transaction])
    @transaction_b = Transaction.new(params[:transaction])
  
    # check to make sure amounts of both records = 0
    if @transaction_a.amount.value == @transaction_b.amount.value
  		# create hash string for both records
    	o = [('a'..'z'),('A'..'Z')].map{|i| i.to_a}.flatten
    	string = (0...50).map{ o[rand(o.length)] }.join
    	@transaction_a.update_attribute :unique_hash, string
    	@transaction_b.update_attribute :unique_hash, string
	    
	    if @transaction_a.save && @transaction_b.save
	      redirect_to transactions_path, notice: "New Transaction Successfully Created"
	    else
	      render :new
	    end
	else
        raise "Error - transactions to not balance"
    end    

  end

  def edit
    @transaction = Transaction.find(params[:id])
  end

  def update
    @transaction = Transaction.find(params[:id])
    if @transaction.update_attributes(params[:transaction])
      redirect_to @transaction, notice: "Transaction Successfully Updated"
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
      redirect_to transactions_path, notice: "Transaction Successfully Destroyed"
  end

end
