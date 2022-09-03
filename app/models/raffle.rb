class Raffle < ApplicationRecord
  belongs_to :creator
  belongs_to :token
  accepts_nested_attributes_for :token
end
