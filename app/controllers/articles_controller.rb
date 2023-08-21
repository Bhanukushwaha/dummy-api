class ArticlesController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :find_article,only: [:show,:update,:destroy, :create_comments, :comments, :likes]
  def index
    articles = Article.all
    render json: articles, each_serializer: ArticleSerializer
  end

  def show
    render json: {data: @article}
  end

  def create
    article = current_user.articles.create(article_params)
    render json: article, each_serializer: ArticleSerializer
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
    @comment = @article.comments.new(comment_params)
    @comment.user_id = current_user.id
    if @comment.save
      if @article.user.present? && (@article.user&.id != @comment.user&.id)
        SendEmailMailer.send_notification(@comment, @article).deliver_now
      end
      render json: {data: @comment}
    else
      return render json: {error: @comment.errors}, status: :unprocessable_entity
    end
  end

  def comments
    comments = []
    @comments = @article.comments
    @comments.each do |comment|
    
      is_like = Like.where(user_id: current_user.id, likeable_id: comment.id, likeable_type: "Comment").present?
      comments << comment.attributes.merge(is_like: is_like)
    end
      render json: {data: comments}
  end

  def likes
    if @article.likes.where(user_id:current_user.id).present?
      return render json: {message: "You have already like this article"}, status: :ok
    else
      @like = @article.likes.new
      @like.user_id = current_user.id
      if @like.save
        if @article.user.present? && (@article.user&.id != @like.user&.id)
          LikeEmailMailer.like_notification(@like, @article).deliver_now
        end
        render json: {data: @like}
      else
        render json: {error: @like.errors}, status: :unprocessable_entity
      end 
    end
  end

  def unlike
    @article = Article.find(params[:id])
    @likes = @article.likes.where(user_id:current_user.id)
    if @likes.present?
       @likes.destroy_all
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
    params.require(:comment).permit(:title, :article_id, :user_id)
  end
end
