class User < ApplicationRecord
  has_many :transactions_to, foreign_key: :to_user, class_name: 'Transaction'
  has_many :transactions_from, foreign_key: :from_user, class_name: 'Transaction'
  has_many :tk_balances, foreign_key: :user, class_name: 'Tk_Balance'
  has_many :tokens, through: :tk_balance
end
