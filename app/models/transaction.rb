class Transaction < ApplicationRecord
  belongs_to :user_from, foreign_key: :from_user, class_name: 'User'
  belongs_to :user_to, foreign_key: :to_user, class_name: 'User'
  belongs_to :token, foreign_key: true
end
