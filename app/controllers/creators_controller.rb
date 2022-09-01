require 'securerandom'
class CreatorsController < ApplicationController
  def index
    @creators = Creator.all
  end

  def new
  end

  def create
  end

  def show
    @creator = Creator.find(params[:id])
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
