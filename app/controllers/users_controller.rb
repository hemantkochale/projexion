class UsersController < ApplicationController
  layout 'application'
  respond_to :html, :json
  before_filter :authenticate_user!, :except => [:new, :create, :edit, :update]

  def index
    @users = @current_account.users
  end

  def show
    @user = @current_account.users.find(params[:id])

    @tasks = @user.tasks

    @project_members = @user.project_members
  end

  def new
    @user = User.new
  end

  def edit
    #authorize! @user
  end

  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to root_path, :notice => 'User was successfully created.' }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    respond_to do |format|
      if @current_user.update_attributes(params[:user])
        flash[:notice] = 'You account was successfully updated.'
        format.html { redirect_to edit_user_path(@user) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def change_password

  end

  def update_password
    respond_to do |format|
      if @current_user.update_attributes(params[:user])
        format.html { redirect_to new_user_session_path, :notice => 'Your password has been successfully updated. Please login again.' }
        format.xml  { head :ok }
      else
        format.html { render :action => :change_password }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
end
