class ApplicationController < ActionController::Base
	before_action :authenticate_user!
  respond_to :json
 helper_method :current_user
 def getting_started
 end
 def current_user
   @current_user ||= User.where(authentication_token: request.headers['token']).first
 end
 def authenticate_user!
   return render json:{error:'401 Unauthorized!'},status: 401 unless current_user
 end
end
