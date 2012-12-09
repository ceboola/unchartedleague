class ArticlesController < ApplicationController
  def index
    @articles = Article.all
  end

  def show
    @article = Article.find(params[:id])
  end

  def create
  end

  def new
  end

  def update
  end

  def edit
  end

end
