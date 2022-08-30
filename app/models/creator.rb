class Creator < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  #devise :database_authenticatable, :registerable,
  #       :recoverable, :rememberable, :validatable
  has_many :raffles, dependent: :destroy
  belongs_to :token

  has_many_attached :files

  validates :token, presence: true
end
