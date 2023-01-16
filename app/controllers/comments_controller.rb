class CommentsController < ApplicationController
	 protect_from_forgery with: :null_session
	def likes
		@comment = Comment.find (params[:id])
		@like = @comment.likes.new
		if @like.save
      		render json: {data: @like}
    	else
      		render json: {error: @like.errors}, status: :unprocessable_entity
    	end
	end
	def unlike	
		@comment = Comment.find(params[:id])		 
		 @like = @comment.likes.find_by(params[:like_id])
		 if @like.present?
     		@like.destroy
	      return render json: {message: "Comment unlike successfully"}
	    else
	      return render json: {error: "Like not found for this comment"}, status: :not_found
    end

	end
end
