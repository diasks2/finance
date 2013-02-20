# -*- encoding : utf-8 -*-
class StaticPagesController < ApplicationController
  def home
  end

  def graph
  	@transactions = Transaction.where("amount > ?", 0).where("category_id != ?", 1).where("category_id != ?", 2).where("category_id != ?", 3).where("category_id != ?", 4).where("category_id != ?", 5).all
    respond_to do |format|
      format.json{
        render :json => JSON.generate(@transactions.as_json(:include => [:category, :group]))
      }
    end
  end
end

