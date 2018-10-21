class UsersController < ApplicationController
  before_action :require_user_logged_in, only: [:index, :show, :followings, :followers]
  before_action :user_find_count, only: [:show, :followers, :followings, :likes]
  
  def index
    @users = User.all.page(params[:page])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = 'ユーザを登録しました。'
      redirect_to @user
    else
      flash.now[:danger] = 'ユーザの登録に失敗しました。'
      render :new
    end
  end

  def new
    @user = User.new
  end

  def show
    @microposts = @user.microposts.order('created_at DESC').page(params[:page])
  end

  def followings
    @followings = @user.followings.page(params[:page])
  end
  
  def followers
    @followers = @user.followers.page(params[:page])
  end
  
  def likes
    @microposts = @user.favoritings.order('created_at DESC').page(params[:page])
  end

  private
  def user_params
    params.require(:user).permit(:name,:email,:password,:password_confirmation)
  end
  
  def user_find_count
    @user = User.find(params[:id])
    counts(@user)
  end
end
