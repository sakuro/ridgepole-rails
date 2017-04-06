$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "ridgepole/rails/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "ridgepole-rails"
  s.version     = Ridgepole::Rails::VERSION
  s.authors     = ["OZAWA Sakuro"]
  s.email       = ["sakuro@2238club.org"]
  s.homepage    = "https://github.com/sakuro/ridgepole-rails"
  s.summary     = "Integrates ridgepole into rails"
  s.description = <<~EOF
  This gem adds two rake tasks: ridgepole:export and ridgepole:apply to your rails project.
  It also substitutes some builtin tasks (db:migrate db:schema:dump etc.)
  EOF
  s.license     = "MIT"

  s.files = Dir["lib/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.0.0"
  s.add_dependency "ridgepole", "~> 0.6.5.beta9"
end
