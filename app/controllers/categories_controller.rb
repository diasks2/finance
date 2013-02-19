class CategoriesController < ApplicationController
  
  def new
    @category = Category.new
  end

  def create
    @category = Category.new(params[:category])
    if @category.save
      redirect_to @category, notice: "New Category Successfully Created"
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
    @categorys = Category.order("id").all
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy
      redirect_to categorys_path, notice: "Category Successfully Destroyed"
  end

end