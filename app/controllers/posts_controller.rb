class PostsController < ApplicationController
  def index
    @posts = Post.all
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      flash[:notice] = "新しく投稿しました"
      redirect_to posts_path
    else
      flash.now[:notice] = "投稿に失敗しました"
      render :new_post_path
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def post_params
    params.permit(:title, :photo, :description)
  end
end
