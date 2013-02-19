class TransactionsController < ApplicationController
  
  def new
    @transaction = Transaction.new
  end

  def create
    @transaction = Transaction.new(params[:transaction])
    # o =  [('a'..'z'),('A'..'Z')].map{|i| i.to_a}.flatten
    # string  =  (0...50).map{ o[rand(o.length)] }.join
    if @transaction.save
      redirect_to @transaction, notice: "New Transaction Successfully Created"
    else
      render :new
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
