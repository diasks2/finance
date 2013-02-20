# -*- encoding : utf-8 -*-
class Group < ActiveRecord::Base
  has_many :categories
  has_many :transactions, :through => :category
  attr_accessible :name

  validates :name, presence: true
end
