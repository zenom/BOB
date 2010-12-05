require 'spec_helper'

describe Notifier::Campfire do

  it { should have_field(:ssl).of_type(Boolean) }

  before(:each) do
    @build = Fabricate(:build, :state => :building)
  end

  it 'should send a failed message' do
    @build.project.campfire.should_receive(:send_failed).with(@build)
    @build.build_failed!
  end

  it 'should send a success message' do
    @build.project.campfire.should_receive(:send_success).with(@build)
    @build.build_completed!
  end

  it 'send message should trigger tinder' do
    connection = mock('Tinder::Campfire')
    room = mock('Tinder::Room')
    message = "[#{@build.project.name}] Build #{@build.id} successful. http://localhost/builds/#{@build.id}"
    Tinder::Campfire.stub!(:new).and_return(connection)
    connection.stub_chain(:find_room_by_name).and_return(room)
    room.should_receive(:speak).with(message) # need to make sure the message is right
    room.should_receive(:leave)
    @build.build_completed!
  end

end
