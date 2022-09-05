class Creator < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :raffles, dependent: :destroy
  has_one_attached :photo
  belongs_to :pale_blue, foreign_key: :pale_blue_id, class_name: 'Token'
  belongs_to :file_key, foreign_key: :file_key_id, class_name: 'Token'

  has_many :nfts

  validates :pale_blue, presence: true
  validates :file_key, presence: true
end
