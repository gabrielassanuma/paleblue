class TokenBalance < ApplicationRecord
  belongs_to :solana_users
  belongs_to :solana_tokens
end
