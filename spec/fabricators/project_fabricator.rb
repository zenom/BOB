Fabricator(:project) do
  name                { Faker::Company.bs }
  scm_type            { 'Bob::Git' }
  scm_path            { Rails.root.join('tmp', 'builds', 'sample') }
  keep_build_count    { 10 }
  fixed_branch        { false }
  branch_name         { 'master' }
  campfire            { Fabricate.build(:campfire) }
end
