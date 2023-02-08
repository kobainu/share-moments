class FavoritesController < ApplicationController
  def create
    Favorite.create(user_id: current_user.id, post_id: params[:id])
    redirect_to posts_path
  end

  def destroy
    favorite = Favorite.find_by(user_id: current_user.id, post_id: params[:id])
    favorite.destroy
    redirect_to posts_path
  end
end
