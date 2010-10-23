# CacheStoreApi

## lazy_cache

Lazily cache the contents of the block. It takes the cache key and time to expiration as arguments.

    CacheStoreApi.lazy_cache("cache-key", 1.week) do
      @my_expensive_models = Model.all(:conditions => "some-expensive-query")
      render_to_string(:template => "my/template/path/index.html")
    end.tap do |html|
      render :text => html
    end

## expire

Expires the given cache key.

    CacheStoreApi.expire("cache-key")

## cache

Access to the raw cache object.

    CacheStoreApi.cache.instance_variable_get("@pool")
