require 'spec_helper'

describe ServiceController do

  describe 'GitHub Postback' do
    let(:project) { Fabricate(:project) }

    before(:each) do 
      @github = ''
      f = File.open(Rails.root + 'spec/mocks/services/github.json')
      f.each_line do |line|
        @github += line
      end
    end

    it 'creates a new commit' do
      post :github, :service_id => project.id.to_s, :payload => @github
    end

  end

end
