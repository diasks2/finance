# -*- encoding : utf-8 -*-
class Category < ActiveRecord::Base
  belongs_to :group
  has_many :transactions
  attr_accessible :group_id, :name

  validates :name, presence: true
  validates :group_id, presence: true

  	def self.to_csv(options = {})
      CSV.generate(options) do |csv|
        csv << column_names
        all.each do |category|
          csv << category.attributes.values_at(*column_names)
        end
      end  
    end
end
