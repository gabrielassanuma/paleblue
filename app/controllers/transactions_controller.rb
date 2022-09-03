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
      redirect_to transaction_path(@transaction), notice: "Transaction was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def transaction_params
    params.require(:transaction).permit(:tk_amount, :token_id)
  end

end
