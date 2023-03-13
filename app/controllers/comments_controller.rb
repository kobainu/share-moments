class CommentsController < ApplicationController
  def create
    post = Post.find(params[:post_id])
    comment = current_user.comments.new(comment_params)
    comment.post_id = post.id
    comment.save
    flash[:notice] = "コメントを投稿しました。"
    redirect_to post_path(post)
  end

  def destroy
    Comment.find_by(id: params[:id], post_id: params[:post_id]).destroy
    flash[:notice] = "コメントを削除しました。"
    redirect_to post_path(params[:post_id])
  end

  private

  def comment_params
    params.require(:comment).permit(:comment)
  end
end
