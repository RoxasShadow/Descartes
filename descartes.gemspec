Kernel.load 'lib/descartes/version.rb'

Gem::Specification.new { |s|
	s.name          = 'descartes'
	s.version       = Descartes.version
	s.author        = 'Giovanni Capuano'
	s.email         = 'webmaster@giovannicapuano.net'
	s.homepage      = 'http://www.giovannicapuano.net'
	s.platform      = Gem::Platform::RUBY
	s.summary       = 'Codo ergo bot.'
	s.description   = 'A serious modular ruby IRC bot.'
 	s.licenses      = 'WTFPL'

  s.require_paths = ['lib']
  s.files         = Dir.glob('lib/**/*')
  s.executables = 'descartes'

  s.add_runtime_dependency 'cinch'
  s.add_runtime_dependency 'cinch-login'
  s.add_runtime_dependency 'nokogiri'
  s.add_runtime_dependency 'crunchyroll'
}