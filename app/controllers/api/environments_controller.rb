class Api::EnvironmentsController < ApplicationController

  def index
    environments = Environment.all
    api_response(:environments => environments)
  end

  def update
    env = Environment.find_by_slug(params[:id])
    api_response(:environment => env)
  end

  def show
    env = Environment.find_by_slug(params[:id])
    if env
      hash = {}
      env.inherited_variables.each do |var|
        hash[var.key] = var.value
      end
      api_response(:config => hash)
    else
      api_response(:error => "No env named #{params[:id]}")
    end
  end

  protected

  def api_response(data)
    respond_to do |format|
      format.json { render :json => data }
      format.xml { render :xml => data }
    end
  end
end
