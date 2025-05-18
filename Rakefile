# frozen_string_literal: true

require "English"

begin
  require "bundler/setup"
rescue LoadError
  puts "You must `gem install bundler` and `bundle install` to run rake tasks"
end

APP_RAKEFILE = File.expand_path("spec/dummy/Rakefile", __dir__)
load "rails/tasks/engine.rake"

load "rails/tasks/statistics.rake"

Bundler::GemHelper.install_tasks

require "rspec/core/rake_task"
require "rake/manifest/task"

Rake::Manifest::Task.new do |t|
  t.patterns = ["*.md", "MIT-LICENSE", "{app,config,db,lib,themes}/**/*"]
end

task default: "manifest:check"

desc "Run all specs in spec directory"
RSpec::Core::RakeTask.new(spec: "app:db:test:prepare")

task default: :spec
