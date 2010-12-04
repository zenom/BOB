class DashboardsController < ApplicationController
  
  # Show all the builds
  def index
    @builds = Build.desc(:created_at, :started_at).limit(20)
  end
end
