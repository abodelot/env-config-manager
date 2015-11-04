class Api::EnvironmentsController < ApplicationController

  def index
    environments = Environments.all
  end

  def update
  end

  def show
    env = Environment.find_by_slug(params[:id])
    if env
      hash = {}
      env.inherited_variables.each do |var|
        hash[var.key] = var.value
      end
      response = { :config => hash }
    else
      response = { :error => "No env named #{params[:id]}" }
    end

    respond_to do |format|
      format.json {
        render :json => response
      }
      format.xml {
        render :xml => response
      }
    end
  end
end
