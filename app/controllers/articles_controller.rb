class ArticlesController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :find_article,only: [:show,:update,:destroy, :create_comments, :comments, :likes]
  def index
    @articles = Article.all
    render json: {data: @articles}
  end

  def show
    render json: {data: @article}
  end

  def create
    article = Article.create(article_params)
    render json: {data: article}
  end

  def update  
    @article.update(article_params)
    render json: {data: @article}
  end

  def destroy
    if @article.destroy
      return render json: {message: "article destroy sussefully"}
    else 
      return render json: {error: @article.errors}, status: :unprocessable_entity
    end 
  end

  def create_comments
    @article = Article.find(params[:id])
    @comments = @article.comments.create(comment_params) 
    render json: {data: @comments}
  end

  def comments     
    @comments = @article.comments
    render json: {data: @comments}
  end

  def likes
    @like = @article.likes.new
    if @like.save
      render json: {data: @like}
    else
      render json: {error: @like.errors}, status: :unprocessable_entity
    end
  end

  def unlike
    @article = Article.find(params[:id])
    @like = @article.likes.find_by(id: params[:like_id])
    if @like.present?
       @like.destroy
      return render json: {message: "Article unlike successfully"}
    else
      return render json: {error: "Like not found for this article"}, status: :not_found
    end
  end



  private 
  def find_article
    @article = Article.find_by(id: params[:id]) 
    if @article.nil?
      return render json: {error: "Article not found"}, status: :not_found
    end 
  end

  def article_params
    params.require(:article).permit(:title, :descreption)
  end

  def comment_params
      params.require(:comment).permit(:title, :article_id)
    end
end
