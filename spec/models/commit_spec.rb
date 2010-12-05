require 'spec_helper'

describe Commit do
  it { should be_referenced_in(:build) }
  it { should be_referenced_in(:project) }
  it { should have_field(:author).of_type(String) }
  it { should have_field(:author_email).of_type(String) }
  it { should have_field(:guid).of_type(String) }
  it { should have_field(:url).of_type(String) }
  it { should have_field(:created_at).of_type(Time) }
  it { should have_field(:updated_at).of_type(Time) }
  it { should have_field(:message).of_type(String) }
  it { should have_field(:branch).of_type(String) }
  it { should have_field(:files_added).of_type(Integer) }
  it { should have_field(:files_removed).of_type(Integer) }
  it { should have_field(:files_modified).of_type(Integer) }

  context "fabricate model" do
    let(:commit) do
      Fabricate(:commit)
    end
    
    it "should not be nil" do
      commit.should_not be_nil
    end

    it 'should have a guid' do
      commit.guid.should_not be_nil
    end

  end
end
