class TokensController < ApplicationController
  def index
    @tokens = Token.all
  end

  def new
    @token = Token.new
  end

  def create
    @token = Token.new(token_params)
    @token.user = current_user

    if @token.save
      create_tk_balance(@token.max_mint)
      @token.minted_so_far = @token.max_mint

      redirect_to token_path(@token)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @token = Token.find(params[:id])
    @tk_balance = TkBalance.find_by(token: @token)
  end

  private

  def my_tokens
    @tokens = Token.where(user: @user)
  end

  def my_token_balances
    @tk_balances = TkBalance.where(user: current_user)
  end

  def create_tk_balance(tk_amount)
    @tk_balance = TkBalance.new(
      tk_amount:,
      token: @token,
      user: @token.user
    )
    @tk_balance.save
  end

  def token_params
    params.require(:token).permit(:nickname, :photo)
  end
end
