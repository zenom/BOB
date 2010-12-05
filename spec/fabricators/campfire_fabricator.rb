Fabricator(:campfire, :class_name => Notifier::Campfire) do
  ssl       { true }
  token     { Digest::SHA1.hexdigest 'testing' }
  room      { 'Test Room' }
  subdomain { 'example.com' }
end
