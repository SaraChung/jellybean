class RepliesController < ApplicationController
	before_action :get_comment

  def create
    @comment.replies << Reply.create(reply_params)

    redirect_to session[:return_to] ||= request.referer
  end

  private

  def get_comment
    @comment = Comment.find comment_id
  end

  def reply_params
    params.require(:reply).permit(:name, :content)
  end

  def comment_id
    params.permit(:comment_id).fetch(:comment_id)
  end
end
