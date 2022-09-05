class Creator < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :raffles, dependent: :destroy
  has_one_attached :photo
  belongs_to :token

  has_many :nfts

  validates :token, presence: true

  include PgSearch::Model
  pg_search_scope :search_by_title,
    against: [:title],
    using: {
      tsearch: { prefix: true }
    }
end
