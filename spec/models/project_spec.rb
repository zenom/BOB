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
  it { should reference_many(:builds) }
  it { should reference_many(:commits) }
  it { should embed_many(:steps) }
  it { should embed_one(:campfire) }

  context "fabricate project" do
    let(:project) do
      Fabricate(:project)
    end

    it { project.should_not be_nil }
    it { project.name.should_not be_nil }
    it { project.scm_type.should eql 'Bob::Git' }
    it { project.steps.count.should eql 4 }
    
  end

  context "building a project" do
    let(:project) do
      Fabricate(:project)
    end

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
      build.perform
      project.steps.count.should eql 4 
    end

    context 'build! method' do

      before(:each) do
        # build commits
        Service::Github.parse(project,load_json('services/github.json'))
      end

      it "should trigger a new build" do
        Build.count.should eql 0
        Delayed::Job.count.should eql 0 
        project.build!
        # we should not have 1 build
        project.builds.count.should eql 1
        # the first build should have the 2 commits we added
        project.builds.first.commits.count.should eql 2
        project.builds.count.should eql 1
      end
    end
  end

end
