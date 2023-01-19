class SendEmailMailer < ApplicationMailer
	def send_notification(comment, article)
		@article_user = article&.user
		@comment_user = comment&.user
		@comment = comment
		mail to: @article_user.email, subject: 'Comment your articles'
	end
end
