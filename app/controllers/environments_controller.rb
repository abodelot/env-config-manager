class EnvironmentsController < ApplicationController
  def index
    redirect_to Environment.find_by_slug!(Environment::DEFAULT_NAME)
  end

  def show
    # Get environments as tree structure
    @environments = Environment.arrange

    @environment = Environment.find_by_slug!(params[:id])
  end
end
