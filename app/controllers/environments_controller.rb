class EnvironmentsController < ApplicationController
  def index
    # Get environments as tree structure
    @environments = Environment.arrange
    @environment = nil
  end

  def show
    @environments = Environment.arrange
    @environment = Environment.find(params[:id])
  end
end
