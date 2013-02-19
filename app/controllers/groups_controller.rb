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
  end

  def index
    @groups = Group.order("id").all
  end

  def destroy
    @group = Group.find(params[:id])
    @group.destroy
      redirect_to groups_path, notice: "Group Successfully Destroyed"
  end

end