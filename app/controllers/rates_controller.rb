class RatesController < ApplicationController
  def new
    @rate = Rate.new
  end

  def create
    @rate = Rate.new(params[:rate])
    if @rate.save
      redirect_to @rate, notice: "New Rate Successfully Created"
    else
      render :new
    end
  end

  def edit
    @rate = Rate.find(params[:id])
  end

  def update
    @rate = Rate.find(params[:id])
    if @rate.update_attributes(params[:rate])
      redirect_to @rate, notice: "Rate Successfully Updated"
    else
      render 'edit'
    end
  end

  def show
    @rate = Rate.find(params[:id])
  end

  def index
    @rates = Rate.order("id").all
  end

  def destroy
    @rate = Rate.find(params[:id])
    @rate.destroy
      redirect_to rates_path, notice: "Rate Successfully Destroyed"
  end
end
