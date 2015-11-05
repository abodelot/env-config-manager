class Api::EnvironmentsController < Api::BaseController

  def index
    environments = Environment.all
    api_response(:environments => environments)
  end

  def update
    env = Environment.find_by_slug(params[:id])

    variables = params[:variables]
    if !variables.is_a? Hash
      api_response(:error => "Variables missing")
    else
      env.create_vars(variables)
      api_response(:environment => env)
    end
  end

  def show
    env = Environment.find_by_slug(params[:id])
    if env
      api_response(:environment => env)
    else
      api_response(:error => "No env named #{params[:id]}")
    end
  end
end
