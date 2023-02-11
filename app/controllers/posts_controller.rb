class PostsController < ApplicationController
  before_action :authenticate_user!
  def index
    @posts = Post.all
  end

  def following
    @posts = Post.where(user_id: [current_user.following_user.ids])
  end

  def search
    if params[:title].present?
      @posts = Post.where('title LIKE ?', "%#{params[:title]}%")
    else
      @posts = Post.none
    end
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
    @posts = Post.where(user_id: @post.user_id).where.not(id: params[:id])
    @user = User.find(@post.user_id)
    @comment = Comment.new
    @comments = @post.comments.reverse_order
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      flash[:notice] = "投稿内容を更新しました"
      redirect_to posts_path
    else
      flash.now[:notice] = "更新に失敗しました"
      render edit_post_path(@post.id)
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    flash[:notice] = "投稿内容を削除しました"
    redirect_to posts_path
  end

  private

  def post_params
    params.require(:post).permit(:title, :photo, :description)
  end
end
