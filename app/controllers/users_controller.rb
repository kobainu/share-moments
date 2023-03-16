class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i(show follows followers)
  def show
    @posts = Post.where(user_id: @user.id)
    @user_favorites = @user.favorites
    @following_users = @user.following_user
    @follower_users = @user.follower_user
  end

  def profile
    @user = User.find(current_user.id)
  end

  def update
    @user = User.find(current_user.id)
    if @user.update(user_params)
      flash[:notice] = "プロフィールを更新しました。"
      redirect_to user_path(@user.id)
    else
      flash.now[:alert] = "プロフィールの更新に失敗しました。"
      render profile_users_path
    end
  end

  def follows
    @users = @user.following_user
  end

  def followers
    @users = @user.follower_user
  end

  private

  def user_params
    params.require(:user).permit(:name, :image, :introduction)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
