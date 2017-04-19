$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "editstore/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "editstore"
  s.version     = Editstore::VERSION
  s.authors     = ["Peter Mangiafico"]
  s.email       = ["pmangiafico@stanford.edu"]
  s.homepage    = ""
  s.summary     = "The editstore gem is used by client web applications (like Revs Digital Library) to stage changes to descriptive metadata in DOR"
  s.description = "The editstore gem is a Rails engine, including all models and migrations needed to connect to the editstore database for caching descriptive metadata edits.  Editstore 2.x is compatible with Rails 4.y.  Edistore 1.x is comptaible with Rails 3.y."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ">= 4.1"
  s.add_dependency "druid-tools",'>= 0.2.0'

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "coveralls"

  s.add_development_dependency "rspec", "~> 3.0"
  s.add_development_dependency "rspec-rails"
  
end
