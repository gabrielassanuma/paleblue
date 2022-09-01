class Creator < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :raffles, dependent: :destroy

  belongs_to :token

  has_many :nfts

  validates :token, presence: true
end
