class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
  end

  def account
    @user = User.find(params[:id])
    @user_from_transactions = []
    Transaction.where(from_user: @user).each do |transaction|
      @user_from_transactions << transaction
    end
    @user_to_transactions = []
    Transaction.where(to_user: @user).each do |transaction|
      @user_to_transactions << transaction
    end
    @user_balances = []
    TkBalance.where(user: @user).each do |balance|
      @user_balances << balance
    end
  end

  def available_downloads
    balances = current_user.tk_balances.where(tk_amount: 1)
    keys = []
    balances.each do |balance|
      keys << balance.token if balance.token.nickname.include?('File Key')
    end
    @creators = []
    keys.each do |key|
      @creators << Creator.find_by(file_key: key)
    end
    files = []
    
  end
end
