class UsersController < ApplicationController
  def profile
    @user = User.find(current_user.id)
  end

  def update
    @user = User.find(current_user.id)
    if @user.update(user_params)
      flash[:notice] = "プロフィールを更新しました"
      redirect_to users_profile_path
    else
      flash.now[:notice] = "更新に失敗しました"
      render :users_profile_path
    end
  end

  private

  def user_params
    params.permit(:name, :profile, :image)
  end
end
