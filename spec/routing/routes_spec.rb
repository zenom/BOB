require 'spec_helper'

describe "test routing" do

  it 'routes /projects/:id/build to projects#build' do
    { :get => '/projects/123123123/build' }.should route_to(
      :controller => 'projects',
      :action => 'build',
      :id => '123123123'
    )
  end

  it 'routes /projects/:id/delete_step to projects#delete_step' do
    { :get => 'projects/123/delete_step' }.should route_to(
      :controller => 'projects',
      :action => 'delete_step',
      :id => '123'
    )
  end

  it 'routes /build/:id/status to builds#build_status' do
    { :get => '/build/123/status' }.should route_to(
      :controller => 'builds',
      :action => 'build_status',
      :id => '123'
    )
  end

  it 'routes /list to builds@latest_builds' do
    { :get => '/list' }.should route_to(
      :controller => 'builds',
      :action => 'latest_builds'
    )
  end

  it 'routes /list/:id to builds#latest_by_project' do
    { :get => '/list/test-app' }.should route_to(
      :controller => 'builds',
      :action => 'latest_by_project',
      :id => 'test-app'
    )
  end

  it 'should route / to dashboards#index' do
    { :get => '/' }.should route_to(
      :controller => 'dashboards',
      :action => 'index'
    )
  end

end
