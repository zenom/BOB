require 'spec_helper'

describe Bob::Git do

  let(:build) { Fabricate(:build) }

  before(:each) do
    build_testrepo
    Runner.stub!(:run).and_return('Hi\nthere')
  end

  after(:each) do
    remove_testrepo
    FileUtils.rm_rf(build.build_dir)
  end

  it 'should build a commit' do
    build.should_receive(:save)
    build.commits.count.should eql 4
    Bob::Git.build_commit(build)
    build.commits.count.should eql 5
  end

  it 'should detect the branch on commits' do
    command = Bob::Git.checkout(build)
    command.should eql "git clone --branch #{build.latest_commit.branch} --depth 1 #{build.project.scm_path} #{build.build_dir}"
  end

  it 'should use master if there is no last commit' do
    build.commits = []
    command = Bob::Git.checkout(build)
    command.should eql "git clone --branch master --depth 1 #{build.project.scm_path} #{build.build_dir}"
  end

end
