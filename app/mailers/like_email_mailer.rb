class LikeEmailMailer < ApplicationMailer
	def like_notification(like, article)
		@article_user = article&.user
		@like_user = like&.user
		mail to: @article_user.email, subject: 'like your articles'
	end
end
