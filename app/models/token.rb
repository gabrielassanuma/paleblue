class Token < ApplicationRecord
  has_many :transactions, dependent: :destroy
  has_many :tk_balances, dependent: :destroy
  has_one :creator, dependent: :destroy
  has_one_attached :photo
  belongs_to :user # who can edit
  validates :tk_address, uniqueness: true

  after_validation :generate_hash, on: :create

  private

  def generate_hash
    self.tk_address = SecureRandom.hex
  end
end
