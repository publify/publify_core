# frozen_string_literal: true

namespace :manifest do
  def gemmable_files
    `git ls-files -z`.split("\x0").reject do |file|
      file.match(%r{^(bin|spec|gemfiles)/}) ||
        file.end_with?("/.keep") ||
        file.start_with?(".") ||
        %w(Manifest.txt Appraisals Gemfile Rakefile publify_core.gemspec).include?(file)
    end
  end

  def manifest_files
    File.open("Manifest.txt").readlines.map(&:chomp)
  end

  desc "Create manifest"
  task :create do
    File.open("Manifest.txt", "w") do |manifest|
      gemmable_files.each { |file| manifest.puts file }
    end
  end

  desc "Check manifest"
  task :check do
    unless gemmable_files == manifest_files
      raise "Manifest check failed, try recreating the manifest"
    end
  end
end
