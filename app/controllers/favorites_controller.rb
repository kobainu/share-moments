class FavoritesController < ApplicationController
  before_action :post_find
  def create
    Favorite.create(user_id: current_user.id, post_id: params[:id])
  end

  def destroy
    favorite = Favorite.find_by(user_id: current_user.id, post_id: params[:id])
    favorite.destroy
  end

  def post_find
    @post = Post.find(params[:id])
  end
end
