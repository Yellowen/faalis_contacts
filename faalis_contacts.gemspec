$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "faalis_contacts/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|

  s.licenses = ['GPL-2']
  s.name        = "faalis_contacts"
  s.version     = FaalisContacts::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of FaalisContacts."
  s.description = "TODO: Description of FaalisContacts."

  s.files = Dir["{app,config,db,lib}/**/*", "LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 4.0.2"

  s.add_development_dependency "sqlite3"

  #s.add_dependency 'faalis'

  s.add_dependency 'jquery-rails'

  s.add_dependency 'uglifier', '>= 1.3.0'

  s.add_dependency 'sass-rails', '~> 4.0.0'

  s.add_dependency 'jbuilder', '~> 1.2'

  s.add_dependency 'globalize', '>= 4.0.0.alpha.2'

end
