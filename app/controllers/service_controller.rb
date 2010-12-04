class ServiceController < ApplicationController
  protect_from_forgery :except => :github

  def github
    # get the params and create a commit entry
    payload = JSON.parse(params[:payload])
    project = Project.find(params[:service_id])
    ## add new build and commit
    Service::Github.parse(project, payload)
    project.build!
    render :text => "OK", :status => 200
  end

end
