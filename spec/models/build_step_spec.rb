require 'spec_helper'

describe BuildStep do
  it { should have_field(:name).of_type(String) }
  it { should have_field(:output).of_type(String) }
  it { should have_field(:state).of_type(String) }
  it { should have_field(:started_at).of_type(Time) }
  it { should have_field(:command).of_type(String) }
  it { should have_field(:completed_at).of_type(Time) }
  it { should be_referenced_in(:build).as_inverse_of(:build_steps) }

  context "good data" do
    before(:each) do
      @project  = Fabricate(:project)
      @build    = Fabricate(:build, :project => @project)
      @build.perform
      @build_steps = @build.build_steps
    end

    it "should have data" do
    end
  end

  context "test formatting" do
    before(:each) do 
      step  = Fabricate.build(:step, :name => "Build Lib", 
        :command => 'rspec spec/models/build_spec.rb')
      @project  = Fabricate(:project, :steps => [step])
      @build    = Fabricate(:build, :project => @project)
      @build.perform
      @build_steps = @build.build_steps
    end

    it "should work" do
    end
  end
end
