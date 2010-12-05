namespace :spec do
  desc "Run all specs with RCov"
  RSpec::Core::RakeTask.new('andy') do |t|
    rm "coverage.data" if File.exist?("coverage.data")
    t.pattern = "./spec/**/*_spec.rb"
    t.rcov = true
    t.rcov_opts = ['-Ispec --exclude', 'fabricators/*,rubygems/*,rcov,.gem/*,blueprints.rb,features/*']
  end
end

