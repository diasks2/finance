class Account < ActiveRecord::Base
    has_many :transactions
    attr_accessible :name, :owner, :phone_number, :address, :url

    validates :name, presence: true
    validates :owner, presence: true

end
