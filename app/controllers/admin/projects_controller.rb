class Admin::ProjectsController < ApplicationController
  respond_to :html, :json
  before_filter :authenticate_user!

  def index
    @project = Project.new
    @projects = @current_account.projects
  end

  def show
    @project = @current_account.projects.find_or_initialize_by(:code => params[:id]) ||  @current_account.projects.find(params[:id])
  end

  def new
    @project = Project.new
    unauthorized! if cannot? :create, @project
  end

  def edit
    @project = @current_account.projects.find_or_initialize_by(:code => params[:id])  ||  @current_account.projects.find(params[:id])
    unauthorized! if cannot? :edit, @project
  end

  def create
    @project = Project.new(params[:project])

    unauthorized! if cannot? :create, @project
    
    @project.account = @current_account
    
    respond_with(@project) do |format|
      if @project.save
        format.html { redirect_to project_path(@project.code), :notice => 'Project was successfully created.' }
      else
        format.html { render :action => "new" }
      end
    end
  end
  
  def update
    @project = @current_account.projects.find(params[:id])
    unauthorized! if cannot? :update, @project

    respond_with(@project) do |format|
      if @project.update_attributes(params[:project])
        format.html { redirect_to edit_admin_project_path(@project.code), :notice => 'Project was successfully updated.' }
      else
        format.html { render :action => "edit" }
      end
    end
  end
  
  def destroy
    @project = @current_account.projects.find(params[:id])

    respond_to do |format|
      if @project.destroy
        format.html { redirect_to admin_projects_path, :notice => 'Project was successfully deleted.' }
      end
    end
  end

  def add_user
    @project = @current_account.projects.find_or_initialize_by(:code => params[:id])
    @users = @current_account.users
  end

  def save_user
    @project = @current_account.projects.find(params[:id])
    @project.users << User.find(params[:project][:users])

    respond_to do |format|
      if @project.save
        format.html { redirect_to admin_project_path(@project.code), :notice => 'User was successfully added.' }  
      else
        format.html { render :add_user }
      end
    end
  end
end