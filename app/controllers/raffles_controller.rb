class RafflesController < ApplicationController
  def index
    @raffles = Raffle.all
  end

  def new
    @raffle = Raffle.new
    @raffle.token = Token.new
    @creator = Creator.find(params[:creator_id])
  end

  def create
    @creator = Creator.find(params[:creator_id])
    @raffle = Raffle.new(raffle_params)
    @raffle.creator = @creator
    @raffle.tag1 = @creator.tag1
    @raffle.tag2 = @creator.tag2
    @raffle.tag3 = @creator.tag3
    build_token(params.dig(:raffle, :token_attributes))
    if @raffle.save
      redirect_to raffle_path(@raffle)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @raffle = Raffle.find(params[:id])
  end

  private

  def raffle_params
    params.require(:raffle).permit(:name, :about, token_attributes: [:nickname, :photo])
  end

  def build_token(attributes)
    raffle_item = Token.new(nickname: attributes[:nickname], photo: attributes[:photo], user: current_user)
    if raffle_item.save
      create_item_balances(raffle_item)
      @raffle.token = raffle_item
    else
      render :new, status: :unprocessable_entity
    end
  end

  def create_item_balances(item)
    creator_balance = TkBalance.new(
      tk_amount: item.max_mint,
      token: item,
      user: current_user
    )
    creator_balance.save

    item.minted_so_far += 1
    item.save
  end
end
