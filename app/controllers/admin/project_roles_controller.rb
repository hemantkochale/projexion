class Admin::ProjectRolesController < ApplicationController
  respond_to :html, :json, :js
  before_filter :authenticate_user!
  load_and_authorize_resource
  	
  def index
    @project_role = ProjectRole.new    
    @project_roles = @current_account.project_roles
  end

  def show
	@project_role = ProjectRole.find(params[:id])
  end

  def edit
	@project_role = ProjectRole.find(params[:id])
  end

  def new
	@project_role = ProjectRole.new
  end

  def create
	@project_role = ProjectRole.new(params[:project_role])
    @project_role.account = @current_account

    respond_with(@project_role) do |format|
      if @project_role.save
        format.html { redirect_to admin_project_role_path(@project_role), :notice => 'Project role was successfully added.' }
        format.js
      else
        format.html { render :action => :new }
        format.js
      end
    end
  end

  def update
	@project_role = ProjectRole.find(params[:id])

    respond_with(@project_role) do |format|
      if @project_role.update_attributes(params[:project_role])
        format.html { redirect_to admin_project_role_path(@project_role), :notice => 'Project role was successfully updated.' }
      else
        format.html { render :action => :edit }
      end
    end
  end

  def destroy
    @project_role = ProjectRole.find(params[:id])

    @project_role.destroy

    respond_to do |format|
      format.html { redirect_to admin_project_roles_path, :notice => 'Project role was successfully deleted.' }
    end
  end
end