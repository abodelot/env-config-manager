class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, use :null_session instead.
  protect_from_forgery with: :null_session

  # Token authentication
  before_action :authenticate_user_from_token!

  # Devise authentication
  before_action :authenticate_user!

  private

  def authenticate_user_from_token!
    # Extract credentials from headers
    user_token = request.headers['Authorization']
    user = User.find_by(authentication_token: user_token)
    # Compare token from database with token from params
    if user
      res = sign_in(user, :store => false)
    end
  end
end
