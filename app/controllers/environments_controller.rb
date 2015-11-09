class EnvironmentsController < ApplicationController
  def index
    # Get environments as tree structure
    @environments = Environment.arrange
    @environment = nil
  end

  def show
    @environments = Environment.arrange
    @environment = Environment.find_by_slug!(params[:id])
  end
end
