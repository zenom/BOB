Bob::Application.routes.draw do

  devise_for :users

  resources :dashboards
  resources :projects
  resources :builds
  resources :users

  match "/projects/:id/build", :to => "projects#build",:as=> :build_project
  match "/projects/:id/delete_step", :to => "projects#delete_step", :as => :delete_step
  match "/build/:id/status", :to => "builds#build_status", :as => :build_status
  match "/list", :to => "builds#latest_builds", :as => :latest_builds
  match "/list(/:id)", :to => "builds#latest_by_project", :as => :latest_by_project

  resources :service do
    post 'github'
  end

  root :to => "dashboards#index"
end
