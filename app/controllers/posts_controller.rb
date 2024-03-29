class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: %i(show edit update destroy)
  def index
    @posts = Post.all
    @tag_list = Tag.all
    @post = current_user.posts.new
  end

  def following
    @posts = Post.where(user_id: [current_user.following_user.ids])
  end

  def favorite_index
    @favorite_posts = current_user.favorites
  end

  def search
    if params[:keyword] != ""
      @keyword = params[:keyword]
      @posts = Post.where(['address LIKE(?) OR camera LIKE(?)', "%#{@keyword}%", "%#{@keyword}%"])
    else
      redirect_to request.referer
    end
  end

  def address_search
    @address = params[:address]
    @filtered_address_posts = Post.where('address LIKE ?', "%#{@address}%").where(hide_location_info: false)
  end

  def tag_search
    @tag_list = Tag.all
    @tag = Tag.find(params[:tag_id])
    @posts = @tag.posts.all
  end

  def camera_search
    @camera = params[:camera]
    @filtered_camera_posts = Post.where('camera LIKE ?', "%#{params[:camera]}%")
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    @post.camera = @post.photo.camera
    @post.lens = @post.photo.lens_model
    @post.iso_speed_ratings = @post.photo.iso_speed_ratings
    @post.exposure_time = @post.photo.exposure_time
    @post.f_number = @post.photo.f_number
    @post.exposure_bias_value = @post.photo.exposure_bias_value
    @post.focal_length = @post.photo.focal_length
    @post.shooting_date_time = @post.photo.date_time_original
    @post.latitude = @post.photo.latitude
    @post.longitude = @post.photo.longitude
    @post.address = Geocoder.search([@post.latitude, @post.longitude]).first.try(:address)
    tag_list = params[:post][:tag_name].split(nil)
    if @post.save
      @post.save_tag(tag_list)
      flash[:notice] = "投稿が完了しました。"
      redirect_to posts_path
    else
      flash.now[:alert] = "投稿に失敗しました。"
      render :new
    end
  end

  def show
    @posts = Post.where(user_id: @post.user_id).where.not(id: params[:id])
    @post_user = User.find(@post.user_id)
    @comment = Comment.new
    @comments = @post.comments.reverse_order
    @post_tags = @post.tags
  end

  def edit
    @tag_list = @post.tags.pluck(:tag_name).join(' ')
  end

  def update
    tag_list = params[:post][:tag_name].split(nil)
    if @post.update(post_params)
      @old_relations = TagMap.where(post_id: @post.id)
      @old_relations.each do |relation|
        relation.delete
      end
      @post.save_tag(tag_list)
      flash[:notice] = "投稿内容を更新しました。"
      redirect_to post_path(@post.id)
    else
      flash.now[:alert] = "投稿内容の更新に失敗しました。"
      render :edit
    end
  end

  def destroy
    @post.destroy
    flash[:notice] = "投稿内容を削除しました。"
    redirect_to posts_path
  end

  private

  def post_params
    params.require(:post).
      permit(:title, :photo, :description, :camera, :lens, :exposure_time, :f_number, :iso_speed_ratings, :exposure_bias_value, :focal_length, :address, :hide_location_info)
  end

  def set_post
    @post = Post.find(params[:id])
  end
end
