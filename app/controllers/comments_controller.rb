class CommentsController < ApplicationController
	 protect_from_forgery with: :null_session
	def likes
		@comment = Comment.find (params[:id])
		if @comment.likes.where(user_id:current_user.id).present?
      return render json: {message: "You have already like this comment"}, status: :ok
		else
			@like = @comment.likes.new
			@like.user_id = current_user.id
			if @like.save
			  if @comment.user.present? && (@comment.user&.id != @like.user&.id)
	        CommentlikeEmailMailer.comment_notification(@like, @comment).deliver_now
	      end
	      	render json: {data: @like}
	    	else
	      	render json: {error: @like.errors}, status: :unprocessable_entity
	    end
	  end
	end
	def unlike		
		@comment = Comment.find(params[:id])		 
		 @likes = @comment.likes.where(user_id:current_user.id)
		if @likes.present?
    	@likes.destroy_all
	      return render json: {message: "Comment unlike successfully"}
	    else
	      return render json: {error: "Like not found for this comment"}, status: :not_found
    end
	end
end
