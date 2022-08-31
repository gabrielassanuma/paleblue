class CreatorsController < ApplicationController
  def new
    @creator = Creator.new
  end

  def create
    @creator = Creator.new(creator_params)
    @creator.token = create_pale_blue_id
    if @creator.save
      redirect_to creator_path(@creator)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @creator = Creator.find(params[:id])
  end

  def edit
    @creator = Creator.find(params[:id])
  end

  def files_new
    @files = Files.new
  end

  def files_create
    @files = Files.new(files_params)
  end

  private

  def create_pale_blue_id
    token = Token.new(
      tk_address: new_tk_address,
      unlimited: false,
      max_mint: 1,
      minted_so_far: 0,
      nickname: "PaleBlue ID #{User.count}",
      user: User.first
    )
    (return token if token.save)
    create_pale_blue_id
  end

  def new_tk_address
    SecureRandom.hex
  end

  def creator_params
    params.require(:creator).permit(:q1, :q2, :q3, :non_profit, :about, :location, :facebook, :instagram, :linkedin, :website, :tag1, :tag2, :tag3, :token, :photos)
  end

  def files_params
    params.require(:files).permit(photos: [])
  end
end
