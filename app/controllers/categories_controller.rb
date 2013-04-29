# -*- encoding : utf-8 -*-
class CategoriesController < ApplicationController
  
  def new
    @category = Category.new
  end

  def create
    @category = Category.new(params[:category])
    if @category.save
      redirect_to new_transaction_path, notice: "New Category Successfully Created"
    else
      render :new
    end
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])
    if @category.update_attributes(params[:category])
      redirect_to @category, notice: "Category Successfully Updated"
    else
      render 'edit'
    end
  end

  def show
    @category = Category.find(params[:id])
  end

  def index
    @categories = Category.order("group_id").order("name").all
    respond_to do |format|
      format.html
      format.csv { send_data Category.to_csv, :filename => "Finance_categories_#{Time.now.to_date.to_s}.csv" }
      format.xls { headers["Content-Disposition"] = "attachment; filename=\"Finance_categories_#{Time.now.to_date.to_s}.xls\"" }
    end  
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy
      redirect_to categorys_path, notice: "Category Successfully Destroyed"
  end

end
