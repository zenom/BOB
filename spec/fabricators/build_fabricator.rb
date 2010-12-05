Fabricator(:build) do
  state       { 'pending' }
  project!  
  commits!(:count => 4)
end
