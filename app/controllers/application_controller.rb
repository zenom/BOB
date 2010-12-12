class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = exception.message
    redirect_to root_url
  end


  layout :layout_by_resource
  def layout_by_resource
    if devise_controller?
      false
    else
      "application"
    end
  end
end
