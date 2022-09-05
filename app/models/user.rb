class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :wlt_address, uniqueness: true
  after_validation :generate_hash, on: :create
  after_commit :send_tokens
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
    # create sol balance for user
    return if User.find(4).nil?

    generator_sol_balance = User.fourth.tk_balances.find_by(token: Token.fifth)
    generator_sol_balance.tk_amount += 30
    generator_sol_balance.save

    TkBalance.create(
      tk_amount: 0,
      token: Token.fifth,
      user: self
    )

    Transaction.create(
      tk_amount: 30,
      token: Token.fifth,
      from_user: User.fourth,
      to_user: self
    )
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
