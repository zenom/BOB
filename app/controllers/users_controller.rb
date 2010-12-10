class UsersController < ApplicationController

  before_filter :find_user, :only => [:edit, :update, :destroy]
  load_and_authorize_resource

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    respond_to do |format|
      if @user.save
        format.html { redirect_to(users_path, :notice => "User created") }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to(users_path, :notice => "User updated.") }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def destroy
    @user.destroy
    redirect_to(users_path)
  end

  def find_user
    @user = User.find(params[:id]) 
  end
  private :find_user
end

