# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
#require 'webmock/rspec'
#require 'vcr'

#VCR.config do |c|
#  c.cassette_library_dir = File.join(Rails.root, 'spec', 'mocks')
#  c.stub_with :webmock
#end

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.include Mongoid::Matchers
  #config.include WebMock::API

  config.mock_with :rspec

  config.before(:each) do
    DatabaseCleaner.orm = "mongoid"
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean
  end
end

# load a json file from the mocks directory
def load_json(file)
  data = ''
  f = File.open(File.join(Rails.root, 'spec', 'mocks', file)) 
  f.each_line do |line|
    data += line
  end
  f.close
  JSON.parse(data)
end

# Used for building a test repo for testing
REPO_SAMPLE_DIR = File.join(Rails.root, 'tmp', 'builds', 'sample')
def build_testrepo
  FileUtils.mkdir_p(REPO_SAMPLE_DIR)
  `cd  #{REPO_SAMPLE_DIR}; git init; echo "my file" > file; git add file; git commit -m "my file added"`
end

def remove_testrepo
  FileUtils.rm_rf(REPO_SAMPLE_DIR)
end
