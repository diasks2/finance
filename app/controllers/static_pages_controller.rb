# -*- encoding : utf-8 -*-
class StaticPagesController < ApplicationController
  def home
  end

  def graph1
    #@transactions = Transaction.includes(:category, :group).where("amount > ?", 0).where("category_id != ?", 1).where("category_id != ?", 2).where("category_id != ?", 3).where("category_id != ?", 4).where("category_id != ?", 5).group("category_id")
    @transactions = Transaction.includes(:category, :group).where("amount > ?", 0).where("groups.id != ?", 1).group("category_id")
    respond_to do |format|
      format.json{
        render :json => JSON.generate(@transactions.as_json(:include => [:category, :group]))
      }
    end
  end
  def graph2
  	#@transactions = Transaction.includes(:category, :group).where("amount > ?", 0).where("groups.id != ?", 1).group("groups.name")
    #@transactions = Transaction.includes(:category, :group).where("amount > ?", 0).where("groups.id != ?", 1).group("groups.id").sum("amount")
    #respond_to do |format|
     # format.json{
     #   render :json => JSON.generate(@transactions.as_json(:include => [:category, :group]))
     # }
    #end
    @transactions = Transaction.includes(:category, :group).where("amount > ?", 0).where("groups.id != ?", 1).group("groups.id").sum("amount")
    respond_to do |format|
      format.html
      format.json do
        render :json => custom_json_for(@transactions)
      end
    end
  end

private
def custom_json_for(value)
  list = value.map do |k, v|
    { :group_id => k,
      :amount => v    
    }
  end
  list.to_json
end

end

