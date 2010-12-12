require File.expand_path(File.dirname(__FILE__) + "/acceptance_helper")

feature "Dashboard" do

  before(:each) do
    @project          = Fabricate(:project)
    @private_project  = Fabricate(:project, :private => true)
    @build            = Fabricate(:build, :project => @project)
    @private_build    = Fabricate(:build, :project => @private_project)
    visit '/dashboards'
  end

  context "public / non-logged in user" do
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
      page.find_link('Log In').should be_visible
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

    scenario "should not see a private build" do
      page.should_not have_css("##{@private_build.id}")
    end
  end


  context "as a client I" do
    let(:user) { Fabricate(:user, :role => 'client') }

    before(:each) do
      @project.users << user
      @project.save
      @private_project.users << user
      @private_project.save
      log_in(user)
    end


    scenario "should see two projects on the dashboard" do
      page.should have_css("##{@build.id}", :count => 1)
      page.should have_css("##{@private_build.id}", :count => 1)
    end

    scenario "should be able to view a public project view" do
      within(:css, "##{@build.id}") do
        page.find_link('Project View').should be_visible
      end
    end

    scenario "should be able to view a private project view" do
      within(:css, "##{@private_build.id}") do
        page.find_link('Project View').should be_visible
      end
    end

    scenario "should be able to delete a build" do
      within(:css, "##{@private_build.id}") do
        page.find_link("Delete").should be_visible
      end
    end

    scenario "should not see a projects dashboard link" do
      page.find_link('Projects').should be_nil
    end

    scenario "should not see a users dashboard link" do
      page.find_link('Users').should be_nil
    end
  end

end
