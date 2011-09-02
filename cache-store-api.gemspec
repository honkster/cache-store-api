# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

require 'cache-store-api/version'

Gem::Specification.new do |s|
  s.name        = "cache-store-api"
  s.version     = CacheStoreApi::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Brian Takita"]
  s.email       = ["brian@honk.com"]
  s.homepage    = "http://github.com/honkster/cache-store-api"
  s.summary     = "Ruby cache methods built on top of Rails and Sinatra caching."
  s.description = "Ruby cache methods built on top of Rails and Sinatra caching."

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec", "~>2.6.0"
  s.add_development_dependency "rr",    "~>1.0.4"
  s.add_development_dependency "rake"
end
