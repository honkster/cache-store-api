module Cacheable
  class TestCache
    attr_reader :data
    def initialize
      @data = {}
    end

    def write(key, value, options = nil)
      data[key] = value
    end

    def read(key, options = nil)
      data[key]
    end

    def delete(key, options = nil)
      data.delete key
    end

    def exist?(key, options = nil)
      data.exists? key
    end
  end
end
