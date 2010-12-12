class ProjectsController < ApplicationController

  before_filter :find_project, :only => [:destroy, :edit, :update, :build, :delete_step]
  load_and_authorize_resource :except => [:create]

  # index, lookup all the sources
  def index
    @projects = Project.paginate :page => params[:page], :per_page => 20
  end

  def new
    @project = Project.new
    @project.steps.build
    @project.build_campfire
  end

  def create
    user_ids = params[:project][:user_ids]
    new_uids = []
    user_ids.each do |id|
      new_uids << id unless id.blank? 
    end
    params[:project][:user_ids] = new_uids
    @project = Project.new(params[:project])
    respond_to do |format|
      if @project.save
        format.html { redirect_to(projects_path, :notice => 'Project created.') }
      else
        format.html { render :action => "new" }
      end
    end
    # hack for some reason it wasn't working with load_and_authorize_resource on new projects
    authorize! :create, @project

  end

  def destroy
    @project.destroy
    redirect_to(projects_path)
  end

  def edit
    if @project.steps.count == 0
      @project.steps.build
    end
    if @project.campfire
      @project.campfire = Notifier::Campfire.new
    end
  end

  def update
    user_ids = params[:project][:user_ids]
    new_uids = []
    user_ids.each do |id|
      new_uids << id unless id.blank? 
    end
    params[:project][:user_ids] = new_uids

    respond_to do |format|
      if @project.update_attributes(params[:project])
        format.html { redirect_to(projects_url, :notice => "Project updated.") }
      else
        format.html { render :action => "edit" }
      end
    end
  end
 
  def build
    @project.build!
    redirect_to(dashboards_url, :notice => "Build request sent.")
    authorize! :update, @project
  end

  def delete_step 
    @step = @project.steps.find(params[:step])
    @step.destroy
    render :text => 'ok'
  end

  def find_project
    @project = Project.where(:slug => params[:id]).first
  end
  private :find_project
  
end
