require 'spec_helper'

describe Build do
  it { should be_referenced_in(:project) }
  it { should reference_many(:commits) }
  it { should reference_many(:build_steps) }

  it { should have_field(:state).of_type(String) }
  it { should have_field(:created_at).of_type(Time) }
  it { should have_field(:started_at).of_type(Time) }
  it { should have_field(:completed_at).of_type(Time) }

  let(:project) { Fabricate(:project) }
  subject { Fabricate(:build, :project => project) }

  context "a good build" do

    before(:each) do
      build_testrepo
      subject.should_receive(:successful_build)
      subject.perform
    end
    after(:each) { remove_testrepo }


    it "should have success as state" do
      subject.state.should eql 'success'
    end

    it "should have 5 build steps" do
      subject.build_steps.count.should eql 5
    end

    it "should have output for a build step" do
      subject.build_steps.first.output.should_not be_nil
    end

    it "should respond to success?" do 
      should be_success
    end

  end


  context "a bad build" do

    before(:each) do
      bad_step  = Fabricate.build(:step, :name => "Bad Step", :command => 'lkjasdfklasdf')
      project  = Fabricate(:project, :steps => [bad_step])
      @build    = Fabricate(:build, :project => project)
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

  it 'should generate a proper build directory' do
    subject.build_dir.should eql(File.join(Rails.root + 'tmp/builds/' + subject.id.to_s))
  end

  it 'should have a duration' do
    subject.duration.should eql 600.0
  end

  it 'should catch when a build has a failed step' do
    step = Fabricate(:build_step, :state => :failed)
    subject.build_steps << step
    subject.has_failure?.should be_true
  end

  it 'should catch when a build passes' do
    step = Fabricate(:build_step, :state => :success)
    subject.build_steps << step
    subject.has_failure?.should be_false
  end

  it 'should provide steps completed' do
    Fabricate(:build_step, :build => subject, :state => :success) # makes up for git checkout step
    2.times { Fabricate(:build_step, :build => subject, :state => :success) }
    2.times { Fabricate(:build_step, :build => subject, :state => :building) }
    subject.steps_completed.should eql 2
  end

  it 'should have a valid latest_commit' do
    subject.commits.last.should eql subject.latest_commit 
  end

  it 'should generate proper build numbers' do
    10.times { Fabricate(:build, :project => project) } 
    2.times { Build.last.destroy }
    build = Fabricate(:build, :project => project)
    build.build_num.should eql 11
  end

  it 'should run pending builds' do
    3.times { |i| Fabricate(:build, :project => project, :created_at => Time.now.utc + i.minutes) }
    project.builds.count.should eql 3
    Build.run_pending_builds(project)
    Delayed::Job.count.should eql 1
    project.builds.count.should eql 1
    project.builds.deleted.count.should eql 0 # shouldn't skew our build ratios
  end
 
  it 'should clean old builds' do
    20.times { |i| Fabricate(:build, :created_at => Time.now.utc + i.minutes, :project => project, :state => :success) }
    Build.count.should eql 20
    Build.clean_old_builds(project.id)
    Build.count.should eql 10
  end

end
