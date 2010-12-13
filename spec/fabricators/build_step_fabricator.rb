Fabricator(:build_step) do
  name          { "MyString" }
  command       { 'echo "MyString"' }
  output        { "MyString" }
  state         { [:waiting, :success, :failed, :building].sample }
  started_at    { 1.minutes.ago } 
  completed_at  { Time.now.utc }
end
