require 'spec_helper'

describe Build do
  it { should be_referenced_in(:project) }
  it { should reference_many(:commits) }
  it { should reference_many(:build_steps) }

  it { should have_field(:state).of_type(String) }
  it { should have_field(:created_at).of_type(Time) }
  it { should have_field(:started_at).of_type(Time) }
  it { should have_field(:completed_at).of_type(Time) }

  context "perform with good data" do
    before(:each) do
      build_testrepo
      @project  = Fabricate(:project)
      @build    = Fabricate(:build, :project => @project)
      @build.should_receive(:successful_build)
      @build.perform
    end

    after(:each) do
      remove_testrepo
    end

    it "should complete successfully" do
      @build.state.should eql 'success'
    end

    it "should have build steps" do
      @build.build_steps.count.should eql 5
    end

    it "should have output in the build steps" do
      @build.build_steps.first.output.should_not be_nil
    end

    it "should respond to success?" do 
      @build.should be_success
    end

    it "latest_commit" do
      @build.commits.last.should eql @build.latest_commit 
    end

  end


  context "perform with bad data" do

    before(:each) do
      bad_step  = Fabricate.build(:step, :name => "Bad Step", :command => 'lkjasdfklasdf')
      @project  = Fabricate(:project, :steps => [bad_step])
      @build    = Fabricate(:build, :project => @project)
      @build.should_receive(:failed_build)
      @build.perform
    end

    it 'should fail with a bad command' do
      @build.state.should eql 'failed' 
    end

    it 'should respond to failed?' do
      @build.should be_failed
    end

  end

  it 'should generate proper build numbers' do
    project = Fabricate(:project)
    10.times { Fabricate(:build, :project => project) } 
    2.times { Build.last.destroy }
    build = Fabricate(:build, :project => project)
    build.build_num.should eql 11
  end
 
  it 'should clean old builds' do
    project = Fabricate(:project)
    20.times { |i| Fabricate(:build, :created_at => Time.now.utc + i.minutes, :project => project, :state => :success) }
    Build.count.should eql 20
    Build.clean_old_builds(project.id)
    Build.count.should eql 10
  end

end
