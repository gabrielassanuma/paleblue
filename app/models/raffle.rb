class Raffle < ApplicationRecord
  belongs_to :creator
  belongs_to :solana_token
end
