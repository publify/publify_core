# frozen_string_literal: true

require "rake/manifest/task"

Rake::Manifest::Task.new do |t|
  t.patterns = ["*.md", "MIT-LICENSE", "{app,config,db,lib,themes}/**/*"]
end
