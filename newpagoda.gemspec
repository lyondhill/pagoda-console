# -*- encoding: utf-8 -*-
require File.expand_path('../lib/pagoda/cli/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Lyon Hill", "Andrew Bennett"]
  gem.email         = ["lyon@pagodabox.com", "andrew@delorum.com"]
  gem.summary       = %q{Pagodabox CLI}
  gem.description   = %q{Pagodabox User facing interface to improve workflow with pagodabx}
  gem.homepage      = "http://www.pagodabox.com"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "newpagoda"
  gem.require_paths = ["lib"]
  gem.version       = Pagoda::CLI::VERSION

  gem.add_development_dependency "rspec"
  gem.add_development_dependency "pry"

  gem.add_dependency "pagoda-client"
  gem.add_dependency "pagoda-tunnel"
  gem.add_dependency "gli"
end