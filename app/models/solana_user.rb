class SolanaUser < ApplicationRecord
  has_many :transactions_to, foreign_key: :address_to_user, class_name: 'SolanaTransaction'
  has_many :transactions_from, foreign_key: :address_from_user, class_name: 'SolanaTransaction'
end
