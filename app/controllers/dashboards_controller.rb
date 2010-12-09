class DashboardsController < ApplicationController
  
  # Show all the builds
  def index
    @builds = Build.desc(:build_num).limit(20)
  end

  def show
    slug = params[:id]
    project = Project.where(:slug => slug).first
    @builds = Build.where(:project_id => project.id).desc(:build_num).limit(20)
  end
end
