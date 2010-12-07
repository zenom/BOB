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
    respond_to do |format|
      format.json { render :json => @builds.to_a.to_json }
    end
  end

  def find_build
    @build = Build.find(params[:id])
  end
  private :find_build

end
