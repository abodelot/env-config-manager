class Api::UsersController < Api::BaseController

  # GET /api/users
  def index
    users = User.all
    api_response(:users => users)
  end

  # GET /api/users/:id
  def show
    user = User.find(params[:id])
    api_response(:user => user)
  end
end
