require "#{File.dirname(__FILE__)}/spec_helper"

describe CacheStoreApi do
  let(:cache) do
    Object.new.tap do |cache|
      stub(cache).exist?  { raise "You should mock me." }
      stub(cache).read    { raise "You should mock me." }
      stub(cache).write   { raise "You should mock me." }
      stub(cache).delete  { raise "You should mock me." }
    end
  end

  let(:cache_store_api) do
    Module.new do
      include CacheStoreApi
      extend  CacheStoreApi::ClassMethods
    end
  end

  before(:each) do
    cache_store_api.set_cache { cache }
  end

  describe ".disable_cache!" do
    it "should set the #caching? to false" do
      cache_store_api.disable_cache!
      cache_store_api.caching?.should == false
    end
  end

  describe ".set_perform_caching" do
    it "sets .caching? to true when truthy and false when falsy" do
      cache_store_api.set_perform_caching {true}
      cache_store_api.caching?.should == true

      cache_store_api.set_perform_caching {false}
      cache_store_api.caching?.should == false

      cache_store_api.set_perform_caching {"hi"}
      cache_store_api.caching?.should == true

      cache_store_api.set_perform_caching {nil}
      cache_store_api.caching?.should == false
    end
  end

  describe ".enable_cache!" do
    it "should set the #caching? to true" do
      cache_store_api.enable_cache!
      cache_store_api.caching?.should == true
    end
  end

  describe ".caching?" do
    it "should reflect the value of @caching_status" do
      cache_store_api.caching?.should be_true

      cache_store_api.disable_cache!

      cache_store_api.caching?.should be_false

      cache_store_api.enable_cache!

      cache_store_api.caching?.should be_true
    end
  end

  describe ".lazy_cache" do
    context "when caching is disabled" do
      context "when a block is given" do
        before(:each) do
          cache_store_api.disable_cache!

          stub(cache).exist?("cached-key") { fail "Cache should not be read from, when disabled!" }
        end

        it "always yields to the given block" do
          cache_store_api.lazy_cache("cached-key") { "some value" }.should == "some value"
        end
      end
    end

    context "when caching is enabled" do
      context "when a block is given" do
        context "when the key exists in the cache" do
          it "returns the value of cache.read" do
            mock(cache).exist?("the-key") {true}
            mock(cache).read("the-key") {"the value"}

            cache_store_api.lazy_cache("the-key") {"new value"}.should == "the value"
          end

        end

        context "when the key does not exist in the cache" do
          context "when an expiration is not given" do
            it "returns the return value of the block and writes that value (expiring in one hour) into the cache" do
              mock(cache).exist?("the-key") {false}
              mock(cache).write("the-key", "new value", :expires_in => 3600)

              cache_store_api.lazy_cache("the-key") {"new value"}.should == "new value"
            end
          end

          context "when an expiration is given" do
            it "returns the return value of the block and writes that value (expiring in the given time) into the cache" do
              mock(cache).exist?("the-key") {false}
              mock(cache).write("the-key", "new value", :expires_in => 7200)

              cache_store_api.lazy_cache("the-key", 7200) {"new value"}.should == "new value"
            end
          end

        end
      end

      context "when a block is not given" do
        it "returns the value of cache.read" do
          mock(cache).read("the-key") {"the value"}

          cache_store_api.lazy_cache("the-key").should == "the value"
        end
      end
    end
  end

  describe ".expire" do
    it "deletes the key in the cache" do
      mock(cache).delete("the-key")
      cache_store_api.expire("the-key")
    end
  end

  describe ".data" do
    it "returns the @data variable of the cache" do
      data = {}
      cache.instance_variable_set(:@data, data)
      cache_store_api.data.should == data
    end
  end

  describe CacheStoreApi::TestCache do
    let(:cache) { CacheStoreApi::TestCache.new }

    describe ".lazy_cache" do
      context "when a block is given" do
        context "when the key exists in the cache" do
          it "returns the value of cache.read" do
            cache.write("the-key", "the value")
            cache.exist?("the-key").should be_true

            cache_store_api.lazy_cache("the-key") {"new value"}.should == "the value"
          end

        end

        context "when the key does not exist in the cache" do
          context "when an expiration is not given" do
            it "returns the return value of the block and writes that value (expiring in one hour) into the cache" do
              cache.exist?("the-key").should be_false

              cache_store_api.lazy_cache("the-key") {"new value"}.should == "new value"
            end
          end

          context "when an expiration is given" do
            it "returns the return value of the block and writes that value (expiring in the given time) into the cache" do
              cache.exist?("the-key").should be_false

              cache_store_api.lazy_cache("the-key", 7200) {"new value"}.should == "new value"
            end
          end

        end
      end

      context "when a block is not given" do
        it "returns the value of cache.read" do
          cache.write("the-key", "the value")

          cache_store_api.lazy_cache("the-key").should == "the value"
        end
      end
    end

    describe ".expire" do
      it "deletes the key in the cache" do
        cache.write("the-key", "the value")
        cache.exist?("the-key").should be_true
        cache_store_api.expire("the-key")
        cache.exist?("the-key").should be_false
      end
    end

    describe ".data" do
      it "returns the @data variable of the cache" do
        cache_store_api.data.should == cache.data
      end
    end
  end
end
