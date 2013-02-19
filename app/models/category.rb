class Category < ActiveRecord::Base
  belongs_to :group
  has_many :transactions
  attr_accessible :group_id, :name

  validates :name, presence: true
  validates :group_id, presence: true
end
