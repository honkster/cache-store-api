module CacheStoreApi
  module ClassMethods
    attr_reader :cache_lambda

    def lazy_cache(key, expiration=3600)
      return cache.read(key) unless block_given?

      if caching?
        return cache.read(key) if cache.exist?(key)

        data = yield
        cache.write(key, data, :expires_in => expiration)
        data
      else
        yield
      end
    end

    def expire(key)
      cache.delete(key)
    end

    def data
      cache.instance_variable_get(:@data)
    end

    def cache
      cache_lambda.call
    end

    def set_cache(&block)
      @cache_lambda = block
    end

    def caching?
      !!perform_caching_lambda.call
    end

    def set_perform_caching(&block)
      @perform_caching_lambda = block
    end

    def enable_cache!
      set_perform_caching do
        true
      end
    end

    def disable_cache!
      set_perform_caching do
        false
      end
    end

    protected
    def perform_caching_lambda
      @perform_caching_lambda || lambda do
        true
      end
    end
  end
end
