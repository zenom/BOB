Fabricator(:commit) do
  author            { 'Andy Holman' }
  author_email      { 'andy@27eleven.com' }
  guid              { Digest::SHA1.hexdigest(Time.now.to_s) }
  url               { |commit| "https://github.com/user/repo/commit/#{commit.guid}" }
  message           { Faker::Company.catch_phrase }
  files_added       { (1..10).to_a.sample }
  files_removed     { 0 }
  files_modified    { (1..10).to_a.sample }
  branch            { ['master', 'development', 'testing'].sample }
end
