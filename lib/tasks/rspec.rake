desc "Run all specs with RCov"
RSpec::Core::RakeTask.new(:rcov) do |t|
  t.pattern = "./spec/**/*_spec.rb"
  t.rcov = true
  t.rcov_opts = ['-Ispec --rails --profile --exclude', 'fabricators/*,rubygems/*,rcov,.gem/*,blueprints.rb,features/*']
end
