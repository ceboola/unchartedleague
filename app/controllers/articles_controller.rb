class ArticlesController < ApplicationController
  load_and_authorize_resource
  
  def index
    @articles = Article.all
  end

  def show
    @article = Article.find(params[:id])
  end

  def create
  end

  def new
    @article = Article.new
  end

  def update
  end

  def edit
  end

end
