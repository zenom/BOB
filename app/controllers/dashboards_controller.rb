class DashboardsController < ApplicationController
  
  # Show all the builds
  def index
    @builds = Build.desc(:build_num).limit(20)
  end
end
