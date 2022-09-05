class Token < ApplicationRecord
  has_many :transactions, dependent: :destroy
  has_many :tk_balances, dependent: :destroy
  has_one :pb_creator, foreign_key: :pale_blue_id, class_name: 'Creator'
  has_one :file_creator, foreign_key: :file_key_id, class_name: 'Creator'
  has_one_attached :photo
  belongs_to :user
  validates :tk_address, uniqueness: true

  after_validation :generate_hash, on: :create

  private

  def generate_hash
    self.tk_address = SecureRandom.hex
  end
end
