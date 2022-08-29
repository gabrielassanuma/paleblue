class SolanaTransaction < ApplicationRecord
  belongs_to :user_from, foreign_key: :address_from_user, class_name: 'SolanaUser'
  belongs_to :user_to, foreign_key: :address_to_user, class_name: 'SolanaUser'
  belongs_to :solana_token
end
