class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :wlt_address, uniqueness: true
  after_validation :generate_hash, on: :create
  after_create :send_tokens
  has_many :transactions_to, foreign_key: :to_user, class_name: 'Transaction', dependent: :destroy
  has_many :transactions_from, foreign_key: :from_user, class_name: 'Transaction', dependent: :destroy
  has_many :tk_balances, foreign_key: :user, class_name: 'TkBalance', dependent: :destroy
  has_many :tokens, dependent: :destroy
  has_many :creators, through: :tokens

  private

  def generate_hash
    self.wlt_address = SecureRandom.hex
  end

  def send_tokens
    donation_tokens = [
      'SOL',
      'ETH',
      'BTC',
      'USDT',
      'USDC',
      'DOGE (;',
      'BNB',
      'BUSD',
      'ATOM'
    ]

    9.times do |index|
      # Seed / Deposit Site Wallet
      this_balance = TkBalance.where(user: User.fourth).where(token: Token.find(index + 5)).first
      this_balance.tk_amount += 36
      this_balance.save

      this_item = Token.find(index + 5)
      this_item.minted_so_far += 36
      this_item.save

      # Fund User
      TkBalance.create(
        token: Token.find(index + 5),
        user: self
      )

      # Send
      Transaction.create(
        tk_amount: 36,
        token: Token.find(index + 5),
        from_user: User.fourth,
        to_user: self
      )
    end
  end

  def creator
    creators.first
  end

  def email_required?
    false
  end

  def email_changed?
    false
  end

  def will_save_change_to_email?
    false
  end
end
