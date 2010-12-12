require File.expand_path(File.dirname(__FILE__) + "/acceptance_helper")

feature "Sessions" do

  let(:user) { Fabricate(:user) }

  context "log in" do
    let(:user) { Fabricate(:user) }

    before(:each) do
      visit '/users/sign_in'
    end

    scenario "should have an email field" do
      page.should have_css('#user_email') 
    end

    scenario "should have a password field" do
      page.should have_css('#user_password')
    end

    scenario "should have a remember me field" do
      page.should have_css('#rememberme')
    end

    scenario "should be able to login" do
      fill_in('Email', :with => user.email)
      fill_in('Password', :with => '123456')
      click_button('Login')
      current_path.should eql "/"
      page.should have_content("Logout")
    end
  end

  context "log out" do

    scenario "should be able to log out" do
      log_in(user)
      page.should have_content("Logout")
      visit '/users/sign_out'
      page.should have_content('Log In')
    end

  end
end
