class DashboardsController < ApplicationController
  
  # Show all the builds
  def index
    @builds = Build.desc(:build_num).limit(20)
  end

  def show
    @slug = params[:id]
    @builds = Build.where(:slug => params[:id]).desc(:build_num).limit(20)
  end
end
