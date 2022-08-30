class Raffle < ApplicationRecord
  belongs_to :creator
  belongs_to :token
end
