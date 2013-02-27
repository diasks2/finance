# -*- encoding : utf-8 -*-
class AccountsController < ApplicationController
  
  def new
    @account = Account.new
  end

  def create
    @account = Account.new(params[:account])
    if @account.save
      redirect_to @account, notice: "New Account Successfully Created"
    else
      render :new
    end
  end

  def edit
    @account = Account.find(params[:id])
  end

  def update
    @account = Account.find(params[:id])
    if @account.update_attributes(params[:account])
      redirect_to @account, notice: "Account Successfully Updated"
    else
      render 'edit'
    end
  end

  def show
    @account = Account.find(params[:id])
    @account_transactions = Transaction.where("account_id = ?", params[:id]).all
  end

  def index
    @accounts = Account.order("internal DESC").order("owner").order("name").all
    respond_to do |format|
      format.html
      format.csv { send_data Account.to_csv, :filename => "Finance_accounts_#{Time.now.to_date.to_s}.csv" }
      format.xls
    end  
  end

  def destroy
    @account = Account.find(params[:id])
    @account.destroy
      redirect_to accounts_path, notice: "Account Successfully Destroyed"
  end

end
