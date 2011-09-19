# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "pagoda/version"

Gem::Specification.new do |s|
  s.name        = "pagoda"
  s.version     = Pagoda::VERSION
  s.authors     = ["Lyon"]
  s.email       = ["lyon@delorum.com"]
  s.homepage    = ""
  s.summary     = %q{getoutahere}
  s.description = %q{imnotfinishedyet}

  s.rubyforge_project = "pagoda"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec"
  s.add_development_dependency "pry"
  s.add_development_dependency "webmock"
  s.add_development_dependency "fakefs"
  
  s.add_dependency "rest-client"
  s.add_dependency "pagoda-client"
  s.add_dependency "pagoda-tunnel"
  s.add_dependency "json_pure"
  s.add_dependency "iniparse"
  
end
