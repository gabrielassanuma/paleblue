class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :wlt_address, uniqueness: true
  has_many :transactions_to, foreign_key: :to_user, class_name: 'Transaction', dependent: :destroy
  has_many :transactions_from, foreign_key: :from_user, class_name: 'Transaction', dependent: :destroy
  has_many :tk_balances, foreign_key: :user, class_name: 'TkBalance', dependent: :destroy
  has_many :tokens, dependent: :destroy

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
