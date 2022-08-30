class Token < ApplicationRecord
  has_many :transactions, dependent: :destroy
  has_many :tk_balances, dependent: :destroy
  has_one :creator, dependent: :destroy

  belongs_to :user # who can edit
end
