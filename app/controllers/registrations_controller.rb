class RegistrationsController < ApplicationController
  skip_before_action  :verify_authenticity_token
  before_action :authenticate_user!, except: [:create] 
  def create
    user = User.new(registration_params)
    if user.save      
      # user = user.as_json(only: [:id,:email, :username,:name,:address,:role,:authentication_token, :image, :created_at])
      user = user.as_json()
      return render json: {status: 200, data: {user: user}, :message =>"Successfuly Signup"} 
    else
      return render json: {status: 401, data: {user: nil, errors: user.errors}, :message =>"SignUp Rollback"} 
    end
  end
  private
    def error_section
      return render json: user.errors, status: :unprocessable_entity
    end
    def rescue_section
      return render json: {status: 500, data: {news: nil}, message: "Something Went Wrong"}
    end
     
    def registration_params
      params.require(:user).permit( :email, :password, :password_confirmation)
    end
end
