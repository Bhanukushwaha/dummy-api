class CommentlikeEmailMailer < ApplicationMailer
	def comment_notification(like, comment)
	  @comment_user = comment&.user
	  @like_user = like&.user
	  mail to: @comment_user.email, subject: 'like your comment'
	end
end
