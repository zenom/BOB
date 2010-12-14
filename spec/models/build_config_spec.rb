require 'spec_helper'

describe BuildConfig do
  it { should have_field(:name).of_type(String) }
  it { should have_field(:env_cmd).of_type(String) }

  it { should embed_many(:steps) }
end
