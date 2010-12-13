require 'spec_helper'

describe Project do
  
  # fields, referenes, validations
  it { should have_field(:name).of_type(String) } 
  it { should have_field(:scm_type).of_type(String) }
  it { should have_field(:keep_build_count).of_type(Integer) }
  it { should have_field(:created_at).of_type(Time) }
  it { should have_field(:updated_at).of_type(Time) }
  it { should have_field(:scm_path).of_type(String) } 
  it { should have_field(:fixed_branch).of_type(Boolean) }
  it { should have_field(:branch_name).of_type(String) }
  it { should have_field(:private).of_type(Boolean) }

  it { should reference_many(:builds) }
  it { should reference_many(:commits) }
  it { should reference_many(:users).stored_as(:array) }
  it { should embed_many(:steps) }
  it { should embed_one(:campfire) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:scm_path) }
  it { should validate_presence_of(:keep_build_count) }

  context "fabricate project" do
    let(:project) { Fabricate(:project) }

    it { project.should_not be_nil }
    it { project.name.should_not be_nil }
    it { project.scm_type.should eql 'Bob::Git' }
    it { project.steps.count.should eql 4 }
  end

  context "building a project" do
    let(:project) { Fabricate(:project) }

    before(:each) do
      base_dir = Rails.root.join('spec', 'mocks', 'repos')
      `mkdir -p #{base_dir.join('test')} && cd #{base_dir.join('test')} && git init && echo "test file" > README && git add README && git commit -m 'README added'`
    end

    after(:each) do
      FileUtils.rm_rf(Rails.root.join('spec', 'mocks', 'repos'))
    end

    it 'perform should work properly' do
      build = Fabricate(:build, :project => project)
      project.steps.count.should eql 4
      build.should_receive(:failed_build)
      build.perform
      project.steps.count.should eql 4 
    end

    context 'build! method' do

      before(:each) do
        # build commits
        Service::Github.parse(project,load_json('services/github.json'))
      end

      it 'should detect running builds' do
        project.build!
        last_build = project.builds.last
        last_build.build!
        project.has_running_builds?.should be true
      end

      it 'should not add another build if one is running' do
        project.build!
        last_build = project.builds.last
        last_build.build! # change state of build to running
        Delayed::Job.count.should eql 1 
        project.build!
        Delayed::Job.count.should eql 1 
      end

      it "should trigger a new build" do
        Build.count.should eql 0
        Delayed::Job.count.should eql 0 
        project.build!
        # we should not have 1 build
        project.builds.count.should eql 1
        # the first build should have the 2 commits we added
        project.builds.first.commits.count.should eql 2
      end
    end

    it 'should calculate total builds' do
      2.times { Fabricate(:build, :project => subject) }
      2.times { Fabricate(:build, :project => subject, :deleted_at => 10.minutes.ago) }
      subject.total_builds.should eql 4
    end

    it 'should calculate failure rate' do
      2.times { Fabricate(:build, :project => subject) }
      2.times { Fabricate(:build, :project => subject, :state => :failed) }
      subject.fail_rate.should eql 50.0
    end

  end


  

end
