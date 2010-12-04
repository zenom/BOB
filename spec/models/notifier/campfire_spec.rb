require 'spec_helper'

describe Notifier::Campfire do
  before(:each) do
    @project = Fabricate(:project)
  end

  it 'should build a room' do
    RAILS_ENV='test'
    ap APP_CONFIG
    RAILS_ENV='production'
    ap APP_CONFIG
    ap @project
  end

end
