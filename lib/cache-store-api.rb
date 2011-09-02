require 'cache-store-api/class_methods'

module CacheStoreApi
  extend ClassMethods

  autoload :TestCache, 'cache-store-api/test_cache'

  def cache
    CacheStoreApi.cache
  end
end
