class Api::VariablesController < ApplicationController
  def show
    env = Environment.where(:name => params[:id]).first
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
