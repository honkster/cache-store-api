require "#{File.dirname(__FILE__)}/spec_helper"

describe CacheStoreApi do
  describe ".lazy_cache" do
    context "when a block is given" do
      context "when the key exists in the cache" do
        it "returns the value of cache.read" do
          mock(cache).exist?("the-key") {true}
          mock(cache).read("the-key") {"the value"}

          CacheStoreApi.lazy_cache("the-key") {"new value"}.should == "the value"
        end

      end

      context "when the key does not exist in the cache" do
        context "when an expiration is not given" do
          it "returns the return value of the block and writes that value (expiring in one hour) into the cache" do
            mock(cache).exist?("the-key") {false}
            mock(cache).write("the-key", "new value", :expires_in => 3600)

            CacheStoreApi.lazy_cache("the-key") {"new value"}.should == "new value"
          end
        end

        context "when an expiration is given" do
          it "returns the return value of the block and writes that value (expiring in the given time) into the cache" do
            mock(cache).exist?("the-key") {false}
            mock(cache).write("the-key", "new value", :expires_in => 7200)

            CacheStoreApi.lazy_cache("the-key", 7200) {"new value"}.should == "new value"
          end
        end

      end
    end

    context "when a block is not given" do
      it "returns the value of cache.read" do
        mock(cache).read("the-key") {"the value"}

        CacheStoreApi.lazy_cache("the-key").should == "the value"
      end
    end
  end

  describe ".expire" do
    it "deletes the key in the cache" do
      mock(cache).delete("the-key")
      CacheStoreApi.expire("the-key")
    end
  end

  describe ".data" do
    it "returns the @data variable of the cache" do
      data = {}
      cache.instance_variable_set(:@data, data)
      CacheStoreApi.data.should == data
    end
  end

  describe CacheStoreApi::TestCache do
    before do
      @cache = CacheStoreApi::TestCache.new
      CacheStoreApi.set_cache do
        cache
      end
    end

    describe ".lazy_cache" do
      context "when a block is given" do
        context "when the key exists in the cache" do
          it "returns the value of cache.read" do
            cache.write("the-key", "the value")
            cache.exist?("the-key").should be_true

            CacheStoreApi.lazy_cache("the-key") {"new value"}.should == "the value"
          end

        end

        context "when the key does not exist in the cache" do
          context "when an expiration is not given" do
            it "returns the return value of the block and writes that value (expiring in one hour) into the cache" do
              cache.exist?("the-key").should be_false

              CacheStoreApi.lazy_cache("the-key") {"new value"}.should == "new value"
            end
          end

          context "when an expiration is given" do
            it "returns the return value of the block and writes that value (expiring in the given time) into the cache" do
              cache.exist?("the-key").should be_false

              CacheStoreApi.lazy_cache("the-key", 7200) {"new value"}.should == "new value"
            end
          end

        end
      end

      context "when a block is not given" do
        it "returns the value of cache.read" do
          cache.write("the-key", "the value")

          CacheStoreApi.lazy_cache("the-key").should == "the value"
        end
      end
    end

    describe ".expire" do
      it "deletes the key in the cache" do
        cache.write("the-key", "the value")
        cache.exist?("the-key").should be_true
        CacheStoreApi.expire("the-key")
        cache.exist?("the-key").should be_false
      end
    end

    describe ".data" do
      it "returns the @data variable of the cache" do
        CacheStoreApi.data.should == cache.data
      end
    end
  end
end
