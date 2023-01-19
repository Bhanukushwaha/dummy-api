class SessionsController < ApplicationController
  skip_before_action  :verify_authenticity_token 
  before_action :authenticate_user!, except: [:create] 
  def create
    begin
      return render json: {status: 401, data: {user: nil}, message: "Request Parameter not valid"} unless params[:user]
      username = params[:user][:email]
      password = params[:user][:password]
      return render json: {status: 401, data: {user: nil}, message: "The request must contain the email and password."} unless username && password
      @user = User.where(email: username).first
      return render json: {status: 401, data: {user: nil}, message: "Invalid username or password"} if @user.blank?
      return render json: {status: 401, data: {user: nil}, message: "Invalid username or password"} unless @user.valid_password?(password)
      return render json: {status: 200, data: {user: current_user}, message: "You have allready Login."} if current_user
      sign_in @user
      return render json: {status: 200, data: {user: @user}, message: "Login Successful"}
    rescue
      rescue_section
    end
  end
  private
    def rescue_section
      return render json: {status: 500, data: {review: nil}, message: "Something Went Wrong"}
    end
end
