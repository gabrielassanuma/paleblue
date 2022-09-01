class Nft < ApplicationRecord
  belongs_to :creator

  has_many_attached :photos
end
