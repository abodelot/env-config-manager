class VariablesController < ApplicationController
  before_action :set_environment
  before_action :set_variable, only: [:show, :edit, :update, :destroy]

  # GET /variables
  # GET /variables.json
  def index
    @variables = @environment.variables
  end

  # GET /variables/1
  # GET /variables/1.json
  def show
  end

  # GET /variables/new
  def new
    @variable = Variable.new
  end

  # GET /variables/1/edit
  def edit
  end


  # POST /variables
  # POST /variables.json
  def create
    @variable = Variable.new(variable_params)
    @variable.environment = @environment
    respond_to do |format|
      if @variable.save
        format.html { redirect_to (environment_path(@environment)), status: 302, notice: 'Variable was successfully created.' }
        format.json { render :show, status: :created, location: @variable }
      else
        format.html { render :new }
        format.json { render json: @variable.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /variables/1
  # PATCH/PUT /variables/1.json
  def update
    respond_to do |format|
      if @variable.update(variable_params)
        format.html { redirect_to (environment_path(@environment)), status: 302, notice: 'Variable was successfully updated.' }
        format.json { render :show, status: :ok, location: @variable }
      else
        format.html { render :edit }
        format.json { render json: @variable.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /variables/1
  # DELETE /variables/1.json
  def destroy
    if @environment && @variable.environment_id !=  @environment.id
      respond_to do |format|
        format.html { redirect_to environment_path(@environment), alert: "#{@variable.key}: inherited variable, can be destroyed only from '#{@variable.environment.name}'" }
        format.json { head :no_content, status: 400 }
      end
    else
      @variable.destroy
      respond_to do |format|
        format.html { redirect_to environment_path(@environment), notice: 'Variable was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_variable
      @variable = Variable.find(params[:id])
    end

    def set_environment
      @environment = Environment.friendly.find(params[:environment_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def variable_params
      params.require(:variable).permit(:key, :value, :environment_id)
    end
end
