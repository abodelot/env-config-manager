class Api::UsersController < Api::BaseController

  # GET /api/users
  def index
    users = User.filter!(params)
    api_response(:users => users)
  end

  # GET /api/users/:id
  def show
    user = User.filter!(params).find(params[:id])
    api_response(:user => user)
  end
end
