require "bundler/gem_tasks"
require "rspec/core/rake_task"


desc "Run all specs"
RSpec::Core::RakeTask.new('spec') do |t|
  t.rspec_opts = ['--colour --format progress']
end

desc "Create tag v#{Pagoda::VERSION}"
task :tag do
  
  puts "tagging version v#{Pagoda::VERSION}"
  `git tag -a v#{Pagoda::VERSION} -m "Version #{Pagoda::VERSION}"`
  `git push origin --tags`
  
end
