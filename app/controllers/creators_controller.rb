require 'securerandom'
class CreatorsController < ApplicationController
  def index
    if params[:query].present?
      @creators = Creator.search_by_title(params[:query])
    else
      @creators = Creator.all
    end
  end

  def new
    @creator = Creator.new
  end

  def create
    @creator = Creator.new(creator_params)
    @creator.token = create_pale_blue_id
    if @creator.save
      redirect_to edit_creator_path(@creator)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @creator = Creator.find(params[:id])
    @creator.update(profile_params) # Will raise ActiveModel::ForbiddenAttributesError
    redirect_to creator_path(@creator)
  end

  def show
    @creator = Creator.find(params[:id])
    @nfts = Nft.where(creator: @creator)
    @raffles = Raffle.where(creator: @creator)
  end

  def edit
    @creator = Creator.find(params[:id])
  end

  def nft_new
    @nft = Nft.new
    @creator = Creator.find(params[:id])
  end

  def nft_create
    @creator = Creator.find(params[:id])
    @nft = Nft.new(nft_params)
    @nft.creator = @creator
    if @nft.save
      redirect_to creator_path(@creator)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def create_pale_blue_id
    user = User.first
    pale_blue_id_number = Transaction.where(from_user: user).size + 1
    token = Token.new(
      nickname: "PaleBlue ID ##{pale_blue_id_number}",
      user:
    )
    if token.save
      create_pb_balances(token)
      send_token_to_applicant(token)
    else
      create_pale_blue_id
    end
    return token
  end

  def create_pb_balances(token)
    pb_balance = TkBalance.new(
      tk_amount: token.max_mint,
      token:,
      user: User.first
    )
    pb_balance.save

    creator_balance = TkBalance.new(
      token:,
      user: current_user
    )
    creator_balance.save
    token.minted_so_far += 1
    token.save
  end

  def send_token_to_applicant(token)
    transaction = Transaction.new(
      tk_amount: 1,
      token:,
      from_user: User.first,
      to_user: current_user
    )
    transaction.save
  end

  def creator_params
    params.require(:creator).permit(:q1, :q2, :q3)
  end

  def profile_params
    params.require(:creator).permit(
      :photo,
      :title,
      :about,
      :location,
      :facebook,
      :twitter,
      :instagram,
      :linkedin,
      :website,
      :discord,
      :tag1,
      :tag2,
      :tag3
    )
  end

  def nft_params
    params.require(:nft).permit(:name, photos: [])
  end
end
