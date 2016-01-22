class EnvironmentsController < ApplicationController
  before_action :set_environment, except: [:index, :new, :create]
  before_action :set_treeview

  # GET /environments
  # GET /environments.json
  def index
    params[:user_id] = current_user.id
    @environments = Environment.filter!(params)

    puts "*"*80
    puts @environments.count
    respond_to do |format|
      format.json {render json: @environments}
      format.html {
        if @environments.empty?
          redirect_to new_environment_path
        else
          render :index
        end
      }
    end
  end

  # GET /environments/:id
  # GET /environments/:id.json
  def show
  end

  # GET /environments/new
  def new
    if !params[:parent_id].nil?
      @parent = Environment.find_by_name_or_id(params[:parent_id])
    end
    @environment = Environment.new(parent: @parent)
    @environment.parent = @parent
  end

  # GET /environments/1/edit
  def edit
  end

  # POST /environments
  # POST /environments.json
  def create
    @environment = Environment.new(environment_params)
    # Add creator to access list
    @environment.users << current_user
    respond_to do |format|
      if @environment.save
        format.html { redirect_to @environment, notice: 'Environment was successfully created.' }
        format.json { render :show, status: :created, location: @environment }
      else
        format.html { render :new }
        format.json { render json: @environment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /environments/1
  # PATCH/PUT /environments/1.json
  def update
    respond_to do |format|
      puts environment_params
      if @environment.update_attributes(environment_params)
        format.html { redirect_to @environment, notice: 'Environment was successfully updated.' }
        format.json { render :show, status: :ok, location: @environment }
      else
        format.html { render :edit }
        format.json { render json: @environment.errors, status: :unprocessable_entity }
      end
    end
  end

  def addvars
    @environment.create_vars(params[:vars])
    respond_to do |format|
      format.html { redirect_to (environment_path(@environment)), notice: 'Variables were successfully created.' }
      format.json { render :show, status: :created, location: @environment }
    end
  end

  def adduser
    user = User.find_by_email(params[:email])
    respond_to do |format|
      if user
        @environment.users << user
        format.html { redirect_to @environment, notice: "User #{user.email} was successfully added to #{@environment.name}" }
        format.json { render :show, status: :ok, location: @environment }
      else
        format.html { redirect_to @environment, status: 302, alert: "Failed, user #{params[:email]} not found" }
        format.json { render json: {error: "Unknow user"}, status: :unprocessable_entity}
      end
    end
  end

  def deluser
    user = User.find_by_email(params[:email])
    respond_to do |format|
      if user
        user.environments.delete(@environment)
        format.html { redirect_to @environment, notice: "#{user.email} was successfully removed from #{@environment.name}" }
        format.json { render :show, status: :ok, location: @environment }
      else
        format.html { redirect_to @environment, status: 302, alert: "Failed to remove user #{params[:email]}" }
        format.json { render json: {error: "Unknow user"}, status: :unprocessable_entity}
      end
    end
  end

  # DELETE /environments/1
  # DELETE /environments/1.json
  def destroy
    @environment.destroy
    respond_to do |format|
      format.html { redirect_to environments_url, notice: 'Environment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_environment
      @environment = Environment.user_id(current_user.id).find_by_name_or_id!(params[:id])
    end

    def set_parent
      @parent = Environment.find_by_name_or_id(params[:environment][:parent_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def environment_params
      if params.key?(:environment) && params[:environment].key?(:parent_id)
        params[:environment][:parent_id] = set_parent.try(:id)
      end
      params.require(:environment).permit(:name, :ancestry, :parent_id, :id)
    end

    def user_environments
      Environment.user_id(current_user.id)
    end

  def set_treeview
    @treeview_root = Environment
      .joins(:users)
      .arrange(users: {id: current_user.id})
  end
end
