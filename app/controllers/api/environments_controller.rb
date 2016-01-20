class Api::EnvironmentsController < Api::BaseController

  # GET /api/environments
  def index
    environments = user_environments
    api_response(:environments => environments)
  end

  # GET /api/environments/:slug
  def show
    env = user_environments.find_by_slug!(params[:id])
    api_response(:environment => env)
  end

  # POST /api/environments
  def create
  end

  # PUT /api/environments/:slug
  def update
    env = user_environments.find_by_slug!(params[:id])
    variables = params[:config]
    if !variables.is_a? Hash
      raise ArgumentError.new('Variables are missing')
    end
    env.create_vars(variables)
    api_response(:environment => env)
  end

  # DELETE /api/environments/:slug
  def destroy
    env = user_environments.find_by_slug!(params[:id])
    env.destroy!

    head :ok
  end

  private

  def user_environments
    Environment.user_id(current_user.id)
  end

end
