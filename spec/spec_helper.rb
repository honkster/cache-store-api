require "rubygems"

require "rspec"

$LOAD_PATH.unshift(File.expand_path("#{File.dirname(__FILE__)}/../lib"))
require "cache-store-api"
require "cache-store-api/test_cache"

RSpec.configure do |configuration|
  configuration.mock_with :rr

  configuration.before do
    @cache = Object.new

    stub(cache).exist? {raise "You should mock me."}
    stub(cache).read {raise "You should mock me."}
    stub(cache).write {raise "You should mock me."}
    stub(cache).delete {raise "You should mock me."}

    CacheStoreApi.set_cache do
      @cache
    end
  end
end

RSpec::Core::ExampleGroup.class_eval do
  attr_reader :cache
end
