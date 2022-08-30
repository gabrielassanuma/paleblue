class Token < ApplicationRecord
  has_many :transactions
  has_many :users, through: :tk_balance
end
