class UsersController < ApplicationController
  before_action :set_environment
  before_action :set_treeview

  def index
    if @environment
      @users = @environment.users
    else
      @users = User.filter!(params).order('email')
    end
    respond_to do |format|
      format.json {render json: @users}
      if @environment
        format.html {render template: "environments/users"}
      else
        format.html {render :index}
      end
    end
  end

  # GET /api/users/:id
  def show
    @user = User.filter!(params).find(params[:id])
  end

  private
  def set_environment
    @environment = Environment.find_by_name_or_id(params[:environment_id])
  end

  def set_treeview
    @treeview_root = Environment.arrange
    @environments = Environment.all
  end

end
