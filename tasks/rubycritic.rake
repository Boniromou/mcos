namespace :rubycritic do
  require 'rubycritic/rake_task'
  desc 'Run all RubyCritic for CI'
  RubyCritic::RakeTask.new(:ci) do |task|
    # Glob pattern to match source files. Defaults to FileList['.'].
    task.paths   = FileList['app']

    task.options = '--no-browser -f html -p reports/rubycritic/'

    # Defaults to false
    task.verbose = true
  end
end
