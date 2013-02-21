# -*- encoding : utf-8 -*-
class Account < ActiveRecord::Base
    has_many :transactions
    attr_accessible :name, :owner, :phone_number, :address, :url, :internal, :liquid

    validates :name, presence: true
    validates :owner, presence: true

    def self.to_csv(options = {})
      CSV.generate(options) do |csv|
        csv << column_names
        all.each do |account|
          csv << account.attributes.values_at(*column_names)
        end
      end  
    end

end
