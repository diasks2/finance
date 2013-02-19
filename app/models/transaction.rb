class Transaction < ActiveRecord::Base
    belongs_to :account
    belongs_to :category
    has_one :group, :through => :category
    attr_accessible :account_id, :date, :converted_amount, :currency, :unique_hash, :category_id

    validates :account_id, presence: true
    validates :date, presence: true
    validates :amount, presence: true
    validates :currency, presence: true
    validates :unique_hash, presence: true
    validates :category_id, presence: true

    def converted_amount
      if currency == "USD"
	  	amount.to_d / 100 if amount
	  else
	  	amount if amount	
	  end	
	end
  
    def converted_amount=(dollars)
      if currency == "USD"	
      	self.amount = dollars.to_d * 100 if dollars.present?
      else
      	self.amount = dollars if dollars.present?
      end	
    end
end
