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
    @redeem = Transaction.new
    @creator = @raffle.creator
    @donation = Transaction.new
    @user_tokens = []
    TkBalance.where(user: current_user).each do |transaction|
      @user_tokens << transaction.token if transaction.token.nickname == 'SOL'
    end
  end

  def redeem
    @raffle = Raffle.find(params[:id])
    @redemption = Transaction.new(redeem_params)
    @redemption.token = Token.fourth
    @redemption.from_user = current_user
    @redemption.to_user = User.third
    if @redemption.save
      @raffle.metadata << @redemption
      @raffle.save
    else
      render :new, status: :unprocessable_entity
    end
  end

  def donation
    @donation = Transaction.new(donation_params)
    @creator = @raffle.creator
    @donation.from_user = current_user
    @donation.to_user = TkBalance.where(token_id: @creator.pale_blue).last.user
    if @donation.save
      # send Creator File Key if user wallet doesn't currently hold it
      # file_keys if current_user.tk_balances.where(token: @creator.file_key).empty?
      raffle_tickets if @transaction.tk_amount >= 2
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def redeem_params
    params.require(:transaction).permit(:tk_amount)
  end

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

  def file_keys
    file_key_balance = current_user.tk_balances.find_by(token: @creator.file_key)
    if file_key_balance.nil?
      new_balance = TkBalance.new(
        token: @creator.file_key,
        user: current_user
      )
      new_balance.save
    end
    send_file_key
  end

  def send_file_key
    creator_file_key_balance = TkBalance.find_by(token: @creator.file_key)
    creator_file_key_balance.tk_amount += 1
    creator_file_key_balance.save
    Transaction.create(
      tk_amount: 1,
      token: @creator.file_key,
      from_user: @transaction.to_user,
      to_user: current_user
    )
    file_key = @creator.file_key
    file_key.minted_so_far += 1
    if file_key.save
      # render tickets account updated
    else
      render :new, status: :unprocessable_entity
    end
  end

  def raffle_tickets
    user_raffle_ticket_balance = current_user.tk_balances.find_by(token: Token.fourth)
    if user_raffle_ticket_balance.nil?
      user_raffle_ticket_balance = TkBalance.new(
        token: Token.fourth,
        user: current_user
      )
      user_raffle_ticket_balance.save
    end
    ticket_amount
  end

  def ticket_amount
    case @donation.tk_amount
    when 2...6
      send_tickets(1)
    when 6...10
      send_tickets(2)
    when 10..Float::INFINITY
      send_tickets(3)
    end
  end

  def send_tickets(amount)
    update_raffle_ticket_gen_balance(amount)
    Transaction.create(
      tk_amount: amount,
      token: Token.fourth,
      from_user: User.third,
      to_user: current_user
    )
    # render tickets sent
    raffle_ticket = Token.fourth
    raffle_ticket.minted_so_far += amount
    if raffle_ticket.save
      # render tickets account updated
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update_raffle_ticket_gen_balance(amount)
    generator_ticket_balance = User.third.tk_balances.find_by(token: Token.fourth)
    generator_ticket_balance.tk_amount += amount
    generator_ticket_balance.save
  end
end
