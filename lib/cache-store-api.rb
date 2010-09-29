module CacheStoreApi
  module CommonMethods
    def lazy_cache(key, expiration=3600)
      if block_given?
        unless output = cache.read(key)
          output = yield
          cache.write(key, output, :expires_in => expiration)
        end
        output
      else
        cache.read(key)
      end
    end

    def expire(key)
      cache.delete(key)
    end

    def data
      cache.instance_variable_get(:@data)
    end
  end
  extend CommonMethods

  extend(Module.new do
    attr_reader :cache_lambda
    def cache
      cache_lambda.call
    end

    def set_cache(&block)
      @cache_lambda = block
    end
  end)

  def cache
    CacheStoreApi.cache
  end
end
