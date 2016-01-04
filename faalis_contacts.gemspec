$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'faalis_contacts/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|

  s.licenses = ['GPL-2']
  s.name        = 'faalis_contacts'
  s.version     = FaalisContacts::VERSION
  s.authors     = ['Sameer Rahmani', 'Behnam Ahmad Khan Beigi']
  s.email       = ['lxsameer@gnu.org', 'yottanami@gnu.org']
  s.homepage    = 'https://github.com/Yellowen/faalis_contacts'
  s.summary     = 'Contacts plugin for Faalis.'
  s.description = 'Contacts plugin for Faalis. Provide very complete contacts application.'

  s.files = Dir["{app,config,db,lib}/**/*", 'LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir["spec/**/*"]

  s.add_dependency 'faalis'
  s.add_dependency 'globalize', '>= 5'

end
