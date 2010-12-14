require 'spec_helper'

describe Step do
  it { should have_field(:name).of_type(String) }
  it { should have_field(:command).of_type(String) }
  it { should have_field(:process_order).of_type(Integer) }
  it { should be_embedded_in(:build_config) }

  it "should parse a formatted command properly" do
    command = "source blah
    command blah
    another command"
    step = Fabricate.build(:step , :command => command)
    step.formatted_command.should eql "source blah && command blah && another command"
  end
end
