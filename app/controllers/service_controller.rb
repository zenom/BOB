class ServiceController < ApplicationController

  def github
    # get the params and create a commit entry
    payload = JSON.parse(params[:payload])
    project = Project.find(params[:service_id])
    ## add new build and commit
    build = Build.new
    build.commits << GitHub.parse(payload)
    render :text => "OK", :status => 200
  end

end
