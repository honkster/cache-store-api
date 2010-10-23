# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

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

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "bundler"

  s.add_development_dependency "rspec"

  s.files        = Dir.glob("{bin,lib}/**/*") + %w(LICENSE README.md ROADMAP.md CHANGELOG.md)
  s.executables  = ['bundle']
  s.require_path = 'lib'
end
