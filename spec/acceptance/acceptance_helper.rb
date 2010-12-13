require 'spec_helper'
require "steak"
require 'capybara/rails'

module Steak::Capybara
  include Rack::Test::Methods
  include Capybara
  
  def app
    ::Rails.application
  end
end

RSpec.configuration.include Steak::Capybara, :type => :acceptance

# Put your acceptance spec helpers inside /spec/acceptance/support
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

def log_in(user)
  visit '/users/sign_in'
  fill_in('Email', :with => user.email)
  fill_in('Password', :with => '123456')
  click_button('Login')

end
