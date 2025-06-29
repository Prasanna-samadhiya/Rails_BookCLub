class BookclubsController < ApplicationController
  before_action :set_bookclub, only: [ :destroy ]

  def index
    @bookclubs = Bookclub.all
  end

  def show
    @bookclub = Bookclub.find(params[:id])
    @users = @bookclub.users
  end

  def create
    @bookclub = Bookclub.new(bookclub_params)
    if @bookclub.save
      redirect_to bookclubs_path, notice: "Bookclub Created"
    else
      @bookclubs = Bookclub.all  # ensure this is set again for rendering index
      render :index, status: :unprocessable_entity
    end
  end

    def join
      @bookclub = Bookclub.find(params[:id])

      if current_user.bookclubs.include?(@bookclub)
        redirect_to bookclubs_path, alert: "You are already a member!"
      else
        current_user.bookclubs << @bookclub
        redirect_to bookclubs_path, notice: "You joined #{@bookclub.name}!"
      end
    end

    def leave
      @bookclub = Bookclub.find(params[:id])
      current_user.bookclubs.delete(@bookclub)
      redirect_to bookclubs_path, notice: "You left #{@bookclub.name}."
    end

  def destroy
    @bookclub.destroy
    redirect_to bookclubs_path, notice: "Bookclub Deleted"
  end

  private

  def set_bookclub
    @bookclub = Bookclub.find(params[:id])
  end

  def bookclub_params
    params.require(:bookclub).permit(:name)
  end
end
