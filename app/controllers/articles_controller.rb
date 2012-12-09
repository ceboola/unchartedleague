class ArticlesController < ApplicationController
  load_and_authorize_resource
  
  def index
    @articles = Article.all
  end

  def show
    @article = Article.find(params[:id])
  end

  def create
    @article = Article.new(params[:article])
    @article.author = current_user
    if @article.save!     
      flash[:success] = "Dodano"      
      redirect_to articles_path
    else
      flash[:error] = "Error"
      redirect_to new_article_path
    end
  end

  def new
    @article = Article.new
  end

  def update
  end

  def edit
  end

end
