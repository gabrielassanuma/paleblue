class Token < ApplicationRecord
  has_many :transactions
  has_many :tk_balances
  belongs_to :user # who can edit
end
