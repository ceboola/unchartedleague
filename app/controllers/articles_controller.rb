class ArticlesController < ApplicationController
  load_and_authorize_resource
  
  def index
    if can? :manage, Article
      @articles = Article.all
    else
      @articles = Article.where('published = ?', TRUE)
    end
  end

  def show
    @article = Article.find(params[:id])
  end

  def new
    @article = Article.new
  end
  
  def create
    @article = Article.new(params[:article])
    @article.author = current_user
    if @article.save   
      flash[:success] = "Dodano"      
      redirect_to article_path(@article)
    else
      flash[:error] = "Error"
      redirect_to new_article_path
    end
  end
    
  def edit
    @article = Article.find(params[:id])
  end
  
  def update
    @article = Article.find(params[:id])
    @article.update_attributes(params[:article])
    if @article.save   
      flash[:success] = "Zaktualizowano"
      redirect_to article_path(@article)
    else
      flash[:error] = "Error"
      redirect_to edit_article_path(@article)
    end
  end
end
