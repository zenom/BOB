require 'spec_helper'
describe Ability do
  context "guest" do
    before(:each) do
      @user = User.new
      @ability = Ability.new(@user)
      @public_project = Fabricate(:project)
      @private_project = Fabricate(:project, :private => true)
    end

    subject { @ability }

    context "project" do
      it { should_not be_able_to(:manage, @public_project) }
      it { should_not be_able_to(:manage, @private_project) }
      it { should_not be_able_to(:read, @private_project) }
      it { should be_able_to(:read, @public_project) }
    end
    context "user" do
      it { should_not be_able_to(:manage, @user) }
    end
    context "build" do
      it { should_not be_able_to(:manage, Build.new) } 
    end
  end

  context "client" do
    before(:each) do
      @user = Fabricate(:user, :role => 'client')
      @ability = Ability.new(@user)
      @public_project = Fabricate(:project)
      @private_project = Fabricate(:project, :private => true)

      @private_project.users << @user
      @private_project.save

      @build = Fabricate(:build, :project => @private_project)
    end
    subject { @ability }

    context "project" do
      it { should_not be_able_to(:manage, @public_project) }
      it { should_not be_able_to(:manage, @private_project) }
      it { should be_able_to(:read, @private_project) }
      it { should be_able_to(:read, @public_project) }
    end

    context "user" do
      it { should_not be_able_to(:manage, User.new) }
    end

    context "build" do
      it { should be_able_to(:manage, @build) } 
    end
  end

  context "admin" do
    before(:each) do
      @user = Fabricate(:user, :role => 'admin')
      @ability = Ability.new(@user)
      @public_project = Fabricate(:project)
      @private_project = Fabricate(:project, :private => true)

      @private_project.users << @user
      @private_project.save

      @build = Fabricate(:build, :project => @private_project)
    end
    subject { @ability }

    it { should be_able_to(:manage, @user) }
    it { should be_able_to(:manage, @public_project) }
    it { should be_able_to(:manage, @private_project) }
    it { should be_able_to(:manage, @build) }
  end

end
