class TransactionsController < ApplicationController
  def index
    @transactions = Transaction.all
  end
  def show
    @token = Transaction.find(params[:id])
  end

  def new
    @transaction = Transaction.new
    @creator = Creator.find(params[:creator_id])
  end

  def create
    @transaction = Transaction.new(transaction_params)
    @transaction.from_user = current_user
    @creator = Creator.find(params[:creator_id])
    @transaction.to_user = @creator.token.user
    if @transaction.save
      redirect_to transaction_path(@transaction)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def transaction_params
    params.require(:transaction).permit(:tk_amount, :token_id)
  end

end
