require 'spec_helper'

describe User do
  it { should have_field(:first_name).of_type(String) }
  it { should have_field(:last_name).of_type(String) }
  it { should have_field(:role).of_type(String) }
  it { should have_field(:email).of_type(String) }
  it { should have_field(:encrypted_password).of_type(String) }
  it { should have_field(:password_salt).of_type(String) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:role) }

  let(:user) { Fabricate(:user) }

  it 'should build their name properly' do
    user.name.should eql "#{user.first_name} #{user.last_name}"
  end
end
