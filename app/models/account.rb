# -*- encoding : utf-8 -*-
class Account < ActiveRecord::Base
    has_many :transactions
    attr_accessible :name, :owner, :phone_number, :address, :url, :internal, :liquid

    validates :name, presence: true
    validates :owner, presence: true
    validates :internal, presence: true

end
