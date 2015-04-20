class ArticlesController < ApplicationController
	before_filter :authenticate_user!, :except => [:index, :show, :tag]

	def new
		@article = Article.new
	end

	def create
		@article = Article.new(article_params)

    if @article.published
      @article.published_at = Time.now
    end

    if @article.save
      redirect_to @article
    else
      render 'new'
    end
	end

	def edit
		@article = Article.find(params[:id])
	end

	def update
		@article = Article.find(params[:id])

    was_published = @article.published

    if @article.update(params[:article].permit(:title, :body, :published, :thumbnail, :address, :latitude, :longitude))
      if not was_published and @article.published
        @article.published_at = Time.now
        @article.save
      end
      redirect_to @article
    else
      render 'edit'
    end
	end

  def index
    page_num = params[:page]
    @articles = Article.paginate(:page => params[:page])
    @article = Article.where(published: true).order(published_at: :desc).page(page_num)

    if page_num.to_i > 1
      @older_articles = @articles
    else
      @newest_article, *@older_articles = @article
    end

    if user_signed_in?
      @unpublished_articles = Article.where(published: false)
    end
  end

  def show
  	@article = Article.find(params[:id])

    if not @article.published
      authenticate_user!
    end
  end

  def destroy
  	@article = Article.find(params[:id])
  	@article.destroy

  	redirect_to articles_path
  end

  def tag
    @articles = Article.tagged_with(tag_param).latest.paginate(page: page_param)

    render 'tag'
  end

  private

  def page_param
    params.permit(:page).fetch(:page) rescue 1
  end

  def tag_param
    params.permit(:tag_name).fetch(:tag_name)
  end

  def article_params
    params.require(:article).permit(:title, :body, :published, :thumbnail, :tag_list, :address, :latitude, :longitude)
  end
end
