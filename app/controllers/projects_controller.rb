class ProjectsController < ApplicationController

  before_filter :find_project, :only => [:destroy, :edit, :update, :build, :delete_step]
  load_and_authorize_resource :except => [:create]

  # index, lookup all the sources
  def index
    @projects = Project.paginate :page => params[:page], :per_page => 20
  end

  def new
    @project = Project.new
    @project.build_configs.build
    ap @project.build_configs.steps
    @project.build_campfire

  end

  def create
    params[:project][:user_ids].delete_if {|x| x.blank? }

    @project = Project.new(params[:project])
    respond_to do |format|
      if @project.save
        format.html { redirect_to(projects_path, :notice => 'Project created.') }
      else
        format.html { render :action => "new" }
      end
    end
    authorize! :create, @project
  end

  def destroy
    @project.destroy
    redirect_to(projects_path)
  end

  def edit
    if @project.campfire
      @project.campfire = Notifier::Campfire.new
    end
  end

  def update
    params[:project][:user_ids].delete_if {|x| x.blank? }

    respond_to do |format|
      if @project.update_attributes(params[:project])
        format.html { redirect_to(projects_url, :notice => "Project updated.") }
      else
        format.html { render :action => "edit" }
      end
    end
  end
 
  def build
    if @project.has_running_builds?
      flash[:error] = "Build already running for #{@project.name} try again in a few minutes."
      redirect_to(dashboards_url)
    else
      @project.build!
      redirect_to(dashboards_url, :notice => "Build request sent.")
    end
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
