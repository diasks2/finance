# -*- encoding : utf-8 -*-
class Group < ActiveRecord::Base
  has_many :categories
  has_many :transactions, :through => :category
  attr_accessible :name

  validates :name, presence: true

    def self.to_csv(options = {})
      CSV.generate(options) do |csv|
        csv << column_names
        all.each do |group|
          csv << group.attributes.values_at(*column_names)
        end
      end  
    end
end
