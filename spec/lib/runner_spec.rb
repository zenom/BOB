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

    it "should source a .bobrc file" do
      `echo 'echo BOBRC' > /tmp/.bobrc` 
      output = Runner.run('/tmp', 'cd /tmp')
      output.should include('BOBRC')
      FileUtils.rm('/tmp/.bobrc')
    end

  end

end
