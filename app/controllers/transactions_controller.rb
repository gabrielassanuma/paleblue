class TransactionsController < ApplicationController
  def index
    @transactions = Transaction.all
  end

  def show
    @transaction = Transaction.find(params[:id])
  end

  def new
    @transaction = Transaction.new
    @creator = Creator.find(params[:creator_id])
    @user_tokens = []
    donation_tokens = [
      'Solana',
      'ETH',
      'BTC',
      'USDT',
      'USDC',
      'DOGE (;',
      'BNB',
      'BUSD',
      'ATOM'
    ]
    TkBalance.where(user: current_user).each do |transaction|
      donation_tokens.size.times do |index|
        @user_tokens << transaction.token if transaction.token.nickname == donation_tokens[index]
      end
    end
  end

  def create
    @transaction = Transaction.new(transaction_params)
    @transaction.from_user = current_user
    @creator = Creator.find(params[:creator_id])
    @transaction.to_user = TkBalance.where(token_id: @creator.pale_blue).last.user
    if @transaction.save
      # send Creator File Key if user wallet doesn't currently hold it
      file_keys if current_user.tk_balances.where(token: @creator.file_key).empty?
      raffle_tickets if @transaction.tk_amount >= 2
      if params[:transaction][:raffle]
        @raffle = Raffle.find(params[:transaction][:raffle])
        redirect_to @raffle, notice: "Transaction was successfully created." and return
      else
        redirect_to @transaction, notice: "Transaction was successfully created." and return
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def transaction_params
    params.require(:transaction).permit(:tk_amount, :token_id)
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
    case @transaction.tk_amount
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
