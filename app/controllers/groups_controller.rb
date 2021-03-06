# -*- encoding : utf-8 -*-
class GroupsController < ApplicationController
  
  def new
    @group = Group.new
  end

  def create
    @group = Group.new(params[:group])
    if @group.save
      redirect_to @group, notice: "New Group Successfully Created"
    else
      render :new
    end
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    @group = Group.find(params[:id])
    if @group.update_attributes(params[:group])
      redirect_to @group, notice: "Group Successfully Updated"
    else
      render 'edit'
    end
  end

  def show
    @group = Group.find(params[:id])
    @categories = Category.where("group_id = ?", params[:id]).all
  end

  def index
    @groups = Group.where("id != ?", 21).order("name").all
    respond_to do |format|
      format.html
      format.csv { send_data Group.to_csv, :filename => "Finance_groups_#{Time.now.to_date.to_s}.csv" }
      format.xls { headers["Content-Disposition"] = "attachment; filename=\"Finance_groups_#{Time.now.to_date.to_s}.xls\"" }
    end  
  end

  def destroy
    @group = Group.find(params[:id])
    @group.destroy
      redirect_to groups_path, notice: "Group Successfully Destroyed"
  end

end
