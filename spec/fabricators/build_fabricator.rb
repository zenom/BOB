Fabricator(:build) do
  state       { 'pending' }
  project!  
  commits!(:count => 4)
  started_at    { 10.minutes.ago }
  completed_at  { Time.now.utc }
end
