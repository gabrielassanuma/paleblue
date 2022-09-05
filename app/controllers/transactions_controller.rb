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
    TkBalance.where(user: current_user).each do |transaction|
      @user_tokens << transaction.token if transaction.token.nickname == 'SOL'
    end
  end

  def create
    @transaction = Transaction.new(transaction_params)
    @transaction.from_user = current_user
    @creator = Creator.find(params[:creator_id])
    @transaction.to_user = TkBalance.where(token_id: @creator.token).last.user
    if @transaction.save
      # send Creator File Key if user wallet doesn't currently hold it
      check_user_raffle_ticket_balance if @transaction.tk_amount >= 2
      redirect_to transaction_path(@transaction), notice: "Transaction was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def transaction_params
    params.require(:transaction).permit(:tk_amount, :token_id)
  end

  def check_user_raffle_ticket_balance
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
