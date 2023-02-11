class PostsController < ApplicationController
  before_action :authenticate_user!
  def index
    @posts = Post.all
    @tag_list = Tag.all
    @post = current_user.posts.new
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

  def tag_search
    @tag_list = Tag.all
    @tag = Tag.find(params[:tag_id]) #クリックしたタグ
    @posts = @tag.posts.all # クリックしたタグに紐付けられた全ての投稿
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    tag_list = params[:post][:tag_name].split(nil)
    if @post.save
      @post.save_tag(tag_list)
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
    @post_tags = @post.tags
  end

  def edit
    @post = Post.find(params[:id])
    @tag_list = @post.tags.pluck(:tag_name).join(' ')
  end

  def update
    @post = Post.find(params[:id])
    tag_list = params[:post][:tag_name].split(nil)
    if @post.update(post_params)
      # 更新時に一度タグとの関連を削除
      @old_relations = TagMap.where(post_id: @post.id)
      @old_relations.each do |relation|
        relation.delete
      end
      # 新たにタグとの関連を登録
      @post.save_tag(tag_list)
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
