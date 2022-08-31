require 'securerandom'
class CreatorsController < ApplicationController
  def new
  end

  def create
  end

  def show
  end

  def edit
  end

  def files_index
  end

  def files_new
  end

  def files_create
  end

  private

  def create_pale_blue_id
    token = Token.new(
      tk_address: new_tk_address,
      unlimited: false,
      max_mint: 1,
      minted_so_far: 0,
      nickname: "PaleBlue ID",
      user: User.first
    )
    (return token if token.save)
    create_pale_blue_id
  end

  def new_tk_address
    SecureRandom.hex
  end
end
