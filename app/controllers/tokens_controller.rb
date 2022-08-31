require 'faker'

class TokensController < ApplicationController
  def index
    @tokens = Token.all
  end

  def new
    @token = Token.new
  end

  def create
    @token = Token.new(token_params)
    @token.tk_address = new_tk_address
    @token.user = current_user
    @token.max_mint = 1
    @token.minted_so_far = 0
    @token.unlimited = false
    if @token.save
      redirect_to token_path(@token), notice: 'token successfully added.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @token = Token.find(params[:id])
  end

  private

  def my_tokens
    @tokens = Token.where(token.user == @user)
  end

  def token_params
    params.require(:token).permit(:nickname, :photo)
  end

  def new_tk_address
    SecureRandom.hex
  end
end
