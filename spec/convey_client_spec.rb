require 'spec_helper'

describe ConveyClient do
  describe "setup" do
    it "should allow me to set an subdomain" do
      ConveyClient.setup do |config|
        config.subdomain = "test"
      end

      ConveyClient.subdomain.should == "test"
      ConveyClient.auth_token.should be_nil
    end

    it "should allow me to set an auth_token" do
      ConveyClient.setup do |config|
        config.auth_token = "asdf"
      end

      ConveyClient.auth_token.should == "asdf"
    end
  end

  describe ".base_url" do
    it "should use the given subdomain" do
      ConveyClient.setup do |config|
        config.subdomain = "test"
      end
      ConveyClient.base_url.should == "http://test.convey.io/api/"
    end
  end

  describe "caching" do
    describe "setup" do
      it "should allow me to set my cache of choice" do
        ConveyClient.setup do |config|
          config.subdomain = "test"
          config.use_cache(:basic_file, 300, { :path => "tmp/" })
        end
        ConveyClient.config.cache.is_a?(Moneta::BasicFile).should be_true
        ConveyClient.config.cache_timeout.should == 300
      end
    end

    describe ".cached_response" do
      before do
        ConveyClient.setup do |config|
          config.subdomain = "test"
          config.use_cache(:memory, 86400)
        end
      end

      it "should return the content if key is in cache" do
        ConveyClient.cache("key", "content")
        ConveyClient.cached_response("key").should == "content"
      end

      it "should return false if key is not in the cache cache" do
        ConveyClient.cached_response("asdflasdklf").should be_nil
      end
    end

    describe ".cached?" do
      it "should be false when there is no cache" do
        ConveyClient.cached?("key").should be_false
      end

      it "should be true if a key is in the cache" do
        ConveyClient.setup do |config|
          config.subdomain = "test"
          config.use_cache(:memory, 86400)
        end
        ConveyClient.cache("key", "content")
        ConveyClient.cached?("key").should be_true
      end

      it "should be false if a key is not in the cache" do
        ConveyClient.setup do |config|
          config.subdomain = "test"
          config.use_cache(:memory, 86400)
        end
        ConveyClient.cached?("key").should be_false
      end

      it "should be false if the entry for key is empty" do
        ConveyClient.setup do |config|
          config.subdomain = "test"
          config.use_cache(:memory, 86400)
        end
        ConveyClient.cache("key", "")
        ConveyClient.cached?("key").should be_false

        ConveyClient.cache("key", nil)
        ConveyClient.cached?("key").should be_false
      end
    end
  end
end
