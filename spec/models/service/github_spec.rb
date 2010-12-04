require 'spec_helper'

describe Service::Github do

  let(:payload) do
    payload = ''
    f = File.open(Rails.root.join('spec', 'mocks', 'services', 'github.json'))  
    f.each_line do |line|
      payload += line
    end
    f.close
    JSON.parse(payload)
  end
  let(:project) do
    Fabricate(:project)
  end

  subject do
    Service::Github.parse(project,payload)
  end

  it "should be able to parse githubs json" do
    subject.first.author.should eql 'Andy Holman'
  end

  it "should find two commits" do
    subject.count.should eql 2
  end

  it "should have githubs guid populated" do
    subject.first.guid.should eql "4885deef39235577eaf5968370b29bca12709e0c"
  end

  it "should have a branch of master" do
    subject.first.branch.should eql 'master'
  end

end
