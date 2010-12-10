class DashboardsController < ApplicationController
  #load_and_authorize_resource   

  # Show all the builds
  def index
    #ap Build.respond_to?('accessible_by')
    @builds = Build.desc(:build_num).limit(20)
    #authorize! :read, @builds

  end

  def show
    slug = params[:id]
    project = Project.where(:slug => slug).first
    @builds = Build.where(:project_id => project.id).desc(:build_num).limit(20)
    authorize! :read, project
  end
end
