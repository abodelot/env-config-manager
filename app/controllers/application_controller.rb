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
    user_email = request.headers['x-user-email']
    user_token = request.headers['x-user-token']

    user = user_email && User.find_by_email(user_email)

    # Compare token from database with token from params
    if user && Devise.secure_compare(user.authentication_token, user_token)
      res = sign_in(user, :store => false)
    end
  end
end
