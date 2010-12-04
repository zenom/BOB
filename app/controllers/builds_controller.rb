class BuildsController < ApplicationController

  def destroy
    @build = Build.find(params[:id])
    @build.destroy

    respond_to do |format|
      format.html { redirect_to(root_url) }
    end

  end

  def show
    @build = Build.find(params[:id])
  end

  def build_status
    @build = Build.find(params[:id])
    render :partial => "build", :layout => false, :locals => {:build => @build}
  end

  def latest_builds
    if params[:id] == 'undefined'
      @builds = Build.desc(:created_at)
    else
      build = Build.find(params[:id])
      @builds = Build.where(:build_num.gt => build.build_num).desc(:created_at)
    end
    render :layout => false
  end

end
