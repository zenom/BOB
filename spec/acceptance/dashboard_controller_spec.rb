require File.expand_path(File.dirname(__FILE__) + "/acceptance_helper")

feature "Dashboard" do

  before(:each) do
    @project          = Fabricate(:project)
    @private_project  = Fabricate(:project)
    @build            = Fabricate(:build, :project => @project)

    visit '/dashboards'
  end

  scenario "should display the dashboard" do
    page.should have_content("Dashboard")
  end

  scenario "should be able to view public builds" do
    page.should have_css("##{@build.id}", :count => 1)
  end

  scenario "should not see a private build when not logged in" do
    build = Fabricate(:build, :project => @private_project)
    page.should_not have_css("##{build.id}")
  end

  scenario "should see the login link" do
    page.find_link('Log In').visible?
  end

  scenario "should see project view for public project" do
    within(:css, "##{@build.id}") do
      page.should have_content("Project View")
    end
  end

  scenario "should not see edit project for a public project" do
    page.should_not have_content("Edit Project")
  end

  scenario "should see details link" do
    page.should have_content("Details")
  end

  scenario "should not see delete link" do
    page.should_not have_content("Delete")
  end

end
