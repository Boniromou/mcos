namespace :spec do
  require 'rspec/core/rake_task'
  desc 'Run all specs for CI'
  RSpec::Core::RakeTask.new(:ci) do |spec|
    Rake::Task['rubycritic:ci'].invoke
    spec.rspec_opts = '-c --format documentation --format html --out reports/spec/index.html'
  end
end
