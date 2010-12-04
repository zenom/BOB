require 'spec_helper' 
describe Runner do

  context "run method" do


    it "should work" do
      Runner.run('/tmp', 'ls -lA')
    end

    it "should have output on error" do
      begin
        Runner.run('/tmp', 'kjadsfkjsadf')
      rescue RunnerError => e
        e.output.should_not be_nil
      end
    end

  end

end
