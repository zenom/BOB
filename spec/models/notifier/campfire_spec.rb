require 'spec_helper'

describe Notifier::Campfire do

  before(:each) do
    @build = Fabricate(:build, :state => :building)
  end

  it 'should send a failed message' do
    #Notifier::Campfire.should_receive(:send_failed)
    Tinder::Campfire.should_receive(:new)
    @build.build_failed!
  end

end
