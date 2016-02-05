class UsersController < ApplicationController
  before_action :set_environment
  before_action :set_treeview

  # GET /users
  # GET /environments/:id/users
  def index
    @users = User.filter!(params)
    respond_to do |format|
      format.json {render json: @users}
      if @environment
        format.html {render template: 'environments/users'}
      else
        format.html {render :index}
      end
    end
  end

  # GET /users/:id
  # GET /environments/:id/users/:id
  def show
    @user = User.filter!(params).find(params[:id])
    respond_to do |format|
      format.json { render json: @user }
      format.html { render :show }
    end
  end

  private

  def set_environment
    if params.key?(:environment_id)
      @environment = Environment.friendly.find(params[:environment_id])
    end
  end

  def set_treeview
    @treeview_root = Environment.arrange
  end
end
