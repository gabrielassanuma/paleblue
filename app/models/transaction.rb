class Transaction < ApplicationRecord
  belongs_to :from_user, foreign_key: :from_user_id, class_name: 'User'
  belongs_to :to_user, foreign_key: :to_user_id, class_name: 'User'
  belongs_to :token

  validate :check_amounts, on: :create
  validates :tk_amount, :token, presence: true

  after_commit :balances_update, on: :create

  def check_amounts
    return if tk_amount.blank?

    from_balance = from_user.tk_balances.find_by(token:)

    return if from_balance.blank?

    return if from_balance.tk_amount >= tk_amount

    errors.add(:tk_amount, "Not enough balance for this token!")
  end

  def balances_update
    from_balance = from_user.tk_balances.find_by(token:)
    from_balance.update(tk_amount: from_balance.tk_amount - tk_amount)
    to_balance = to_user.tk_balances.find_by(token:)
    to_balance.update(tk_amount: to_balance.tk_amount + tk_amount)
  end
end
