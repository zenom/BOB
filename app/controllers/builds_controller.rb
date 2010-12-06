class BuildsController < ApplicationController

  #before_filter :find_build, :except => [:latest_builds, :latest_builds_by_project]

  def destroy
    @build.destroy
    respond_to do |format|
      format.html { redirect_to(root_url) }
    end
  end

  def show
  end

  def build_status
    render :partial => "build", :layout => false, :locals => {:build => @build}
  end

  def latest_builds
    @builds = Build.desc(:build_num)

    begin
      if params[:id]
        project = Project.where(:slug => params[:id]).first
        @builds.where(:project_id => project.id)
      end
    rescue
      project = nil
    end

    project.nil? ? render(:text => "Not Found", :status => 404) :  render(:layout => false)
  end

  def find_build
    @build = Build.find(params[:id])
  end
  private :find_build

end
