# frozen_string_literal: true

# Maintain your gem's version:
require_relative "lib/publify_core/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "publify_core"
  s.version     = PublifyCore::VERSION
  s.authors     = ["Matijs van Zuijlen", "Yannick François",
                   "Thomas Lecavellier", "Frédéric de Villamil"]
  s.email       = ["matijs@matijs.net"]
  s.homepage    = "https://publify.github.io/"
  s.summary     = "Core engine for the Publify blogging system."
  s.description = "Core engine for the Publify blogging system, formerly known as Typo."
  s.license     = "MIT"

  s.files       = File.read("Manifest.txt").split

  s.required_ruby_version = ">= 3.2.0"

  s.add_dependency "aasm", ">= 5", "< 7"
  s.add_dependency "akismet", "~> 3.0"
  s.add_dependency "bootstrap", "~> 5.3"
  s.add_dependency "cancancan", "~> 3.0"
  s.add_dependency "carrierwave", "~> 3.0"
  s.add_dependency "commonmarker", "~> 2.3"
  s.add_dependency "devise", "~> 5.0", ">= 5.0.4"
  s.add_dependency "devise-i18n", "~> 1.16"
  s.add_dependency "fog-aws", "~> 3.2"
  s.add_dependency "fog-core", "~> 2.2"
  s.add_dependency "html-pipeline", "~> 3.2"
  s.add_dependency "jquery-rails", ">= 4.5", "< 4.7"
  s.add_dependency "jquery-ui-rails", ">= 7", "< 9"
  # Prevent use of json 3 which is incompatible with supported Rails versions
  s.add_dependency "json", "~> 2.0"
  s.add_dependency "kaminari", ["~> 1.2", ">= 1.2.1"]
  s.add_dependency "marcel", ">= 1.0", "< 1.3"
  s.add_dependency "mini_magick", "~> 5.4"
  # Force minimum nokogiri version to avoid security issues
  s.add_dependency "nokogiri", ">= 1.12.5"
  s.add_dependency "rack", ">= 2.2.3"
  s.add_dependency "rails", [">= 7.1.0", "< 8.1"]
  s.add_dependency "rails_autolink", "~> 1.1.0"
  s.add_dependency "rails-i18n", ">= 6.0", "< 8.2"
  s.add_dependency "rails-timeago", "~> 2.0"
  s.add_dependency "recaptcha", ["~> 5.0"]
  s.add_dependency "rubypants", "~> 0.7.0"
  s.add_dependency "sassc-rails", "~> 2.0"
  s.add_dependency "twitter", ">= 7.0", "< 8.4"
  s.add_dependency "uuidtools", ">= 2.2", "< 3.1"
  s.add_dependency "zxcvbn", "~> 1.0"

  s.metadata["rubygems_mfa_required"] = "true"
end
