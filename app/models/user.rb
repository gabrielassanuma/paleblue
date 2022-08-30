class User < ApplicationRecord
  has_many :transactions_to, foreign_key: :to_user, class_name: 'Transaction', dependent: :destroy
  has_many :transactions_from, foreign_key: :from_user, class_name: 'Transaction', dependent: :destroy
  has_many :tk_balances, foreign_key: :user, class_name: 'TkBalance', dependent: :destroy
  has_many :tokens, dependent: :destroy
end
