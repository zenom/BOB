Fabricator(:step) do
  name      { Fabricate.sequence(:step_number, 1) { |i| "Step ##{i}" }}
  command   { 'echo "HELLO"; echo "GOODBYE"' }
end
