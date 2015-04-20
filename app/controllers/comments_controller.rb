class CommentsController < ApplicationController
	before_filter :authenticate_user!, :only => :destroy

  def create
    @article = Article.find(params[:article_id])
    @comment = @article.comments.create(params[:comment].permit(:title,:body))

    if @comment.save
      redirect_to article_path(@article)
    else
      @article.reload
      render :template => "articles/show"
    end
  end

  def destroy
    @article = Article.find(params[:article_id])
    @comment = @article.comments.find(params[:id])
    @comment.destroy
    redirect_to article_path(@article)
  end
end
