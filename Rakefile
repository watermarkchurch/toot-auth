require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

task :environment do
  $LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
  require 'toot/auth'
end

load './lib/tasks/toot-auth.rake'
