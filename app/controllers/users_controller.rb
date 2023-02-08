class UsersController < ApplicationController
  before_action :authenticate_user!
  def show
    @user = User.find(params[:id])
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
      flash[:notice] = "プロフィールを更新しました"
      redirect_to profile_users_path
    else
      flash.now[:notice] = "更新に失敗しました"
      render profile_users_path
    end
  end

  def follows
    user = User.find(params[:id])
    @users = user.following_user
  end

  def followers
    user = User.find(params[:id])
    @users = user.follower_user
  end

  private

  def user_params
    params.require(:user).permit(:name, :image, :introduction)
  end
end
