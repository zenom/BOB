class ProjectsController < ApplicationController

  # index, lookup all the sources
  def index
    @projects = Project.paginate :page => params[:page], :per_page => 20
  end

  def new
    @project = Project.new
    @project.steps.build
    @project.build_campfire
    #@project.campfire.build = Notifier::Campfire.new
    #ap @project.campfire
  end

  def create
    @project = Project.new(params[:project])
    respond_to do |format|
      if @project.save
        format.html { redirect_to(projects_path, :notice => 'Project created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy
    redirect_to(projects_path)
  end

  def edit
    @project = Project.find(params[:id]) 
    if @project.steps.count == 0
      @project.steps.build
    end
    if @project.campfire
      @project.campfire = Notifier::Campfire.new
   end
  end

  def update
    respond_to do |format|
      @project = Project.find(params[:id])
      if @project.update_attributes(params[:project])
        format.html { redirect_to(projects_url, :notice => "Project updated.") }
      else
        format.html { render :action => "edit" }
      end
    end
  end
 
  def build
    @project = Project.find(params[:id])
    @project.build!
    redirect_to(dashboards_url, :notice => "Build request sent.")
  end

  def delete_step 
    project = Project.find(params[:id])
    @step = project.steps.find(params[:step])
    @step.destroy
    render :text => 'ok'
  end
  
end
