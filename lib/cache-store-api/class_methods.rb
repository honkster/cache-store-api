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
      self.caching_status == :enabled
    end

    def enable_cache!
      self.caching_status = :enabled
    end

    def disable_cache!
      self.caching_status = :disabled
    end

    protected
    def caching_status
      @caching_status || self.caching_status = :enabled
    end

    def caching_status=(status)
      raise ArgumentError unless [:enabled, :disabled].include? status
      @caching_status = status
    end
  end
end
