class UsersController < ApplicationController
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

  private

  def user_params
    params.require(:user).permit(:name, :image, :introduction)
  end
end
