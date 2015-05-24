Kernel.load 'lib/descartes/version.rb'

Gem::Specification.new { |s|
  s.name          = 'descartes'
  s.version       = Descartes::VERSION
  s.author        = 'Giovanni Capuano'
  s.email         = 'webmaster@giovannicapuano.net'
  s.homepage      = 'http://www.giovannicapuano.net'
  s.platform      = Gem::Platform::RUBY
  s.summary       = 'Codo ergo bot.'
  s.description   = 'A serious modular ruby IRC bot.'
  s.licenses      = 'WTFPL'

  s.require_paths = ['lib']
  s.files         = Dir.glob('lib/**/*')
  s.executables   = 'descartes'

  s.add_runtime_dependency 'cinch',          '~> 2.2'
  s.add_runtime_dependency 'cinch-login',    '~> 0.1'
  s.add_runtime_dependency 'cinch-colorize', '~> 0.3'

  s.add_runtime_dependency 'nokogiri',       '~> 1.6'
  s.add_runtime_dependency 'crunchyroll',    '~> 0.9', '>= 0.9.8'
  s.add_runtime_dependency 'htmlentities',   '~> 4.3'
  s.add_runtime_dependency 'json',           '~> 1.8'
  s.add_runtime_dependency 'treccani',       '~> 0.3'
  s.add_runtime_dependency 'rockstar',       '~> 0.8'
  s.add_runtime_dependency 'assonnato',      '~> 0.8'
  s.add_runtime_dependency 'arnaldo',        '~> 0.1'
}
