class DashboardsController < ApplicationController
  #load_and_authorize_resource   

  # Show all the builds
  def index
    allowed_project_ids = []
    projects = current_user.nil? ? Project.public_projects : Project.allowed_projects(current_user)
    projects.each { |project| allowed_project_ids << project.id.to_s }

    @builds = Build.any_in(:project_id => allowed_project_ids).desc(:build_num).limit(20)
    #authorize! :read, @builds

  end

  def show
    slug = params[:id]
    project = Project.where(:slug => slug).first
    @builds = Build.where(:project_id => project.id).desc(:build_num).limit(20)
    authorize! :read, project
  end
end
