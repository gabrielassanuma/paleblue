class Raffle < ApplicationRecord
  belongs_to :creator
  has_one :token
end
