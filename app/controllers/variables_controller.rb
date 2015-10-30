class VariablesController < ApplicationController

  def create
    variable = Variable.create!(variable_params)
    redirect_to variable.environment
  end

  def update
    variable = Variable.find_by_id(params[:id])
    variable.update_attributes!(variable_params)
    if request.xhr?
      render :json => variable
    end
  end


  private

  def variable_params
    params.require(:variable).permit(:key, :value, :environment_id)
  end
end
