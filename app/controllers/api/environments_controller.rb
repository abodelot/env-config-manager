class Api::EnvironmentsController < Api::BaseController

  # GET /api/environments
  def index
    environments = Environment.filter!(params)
    api_response(:environments => environments)
  end

  # GET /api/environments/:slug
  def show
    env = Environment.find_by_slug!(params[:id])
    api_response(:environment => env)
  end

  # PUT /api/environments/:slug
  def update
    env = Environment.find_by_slug!(params[:id])
    variables = params[:config]
    if !variables.is_a? Hash
      raise ArgumentError.new('Variables are missing')
    end
    env.create_vars(variables)
    api_response(:environment => env)
  end
end
