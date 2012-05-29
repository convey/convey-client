require 'spec_helper'

describe ConveyClient::Request do
  describe "#url" do
    before do
      @request = ConveyClient::Request.new("this/is/a/path")
    end

    describe "with no auth token" do
      before do
        ConveyClient.setup do |config|
          config.subdomain = "test"
        end
      end

      it "should return the base url plus the requests path" do
        @request.url.to_s.should == "http://test.convey.io/api/this/is/a/path"
      end
    end

    describe "with an auth token" do
      before do
        ConveyClient.setup do |config|
          config.subdomain = "test"
          config.auth_token = "basdfasdfasdf"
        end
      end

      it "should return the base url plus the requests path" do
        @request.url.to_s.should == "http://test.convey.io/api/this/is/a/path?token=basdfasdfasdf"
      end
    end
  end

  describe "#execute" do
    before do
      ConveyClient.setup do |config|
        config.subdomain = "test"
      end
    end

    describe "when a response is not a 200" do
      before do
        FakeWeb.register_uri(:get, "http://test.convey.io/api/my/path",
                             :body => "404", :status => ["404", "Not Found"])
      end

      describe "when raise_request_errors is set to false" do
        before do
          ConveyClient.setup do |config|
            config.subdomain = "test"
            config.raise_request_errors = false
          end
        end

        it "returns an empty array" do
          ConveyClient::Request.execute("my/path").should == "[]"
        end
      end

      describe "when raise_request_errors is set to true" do
        before do
          ConveyClient.setup do |config|
            config.subdomain = "test"
            config.raise_request_errors = true
          end
        end

        it "raise a request error" do
          lambda do
            ConveyClient::Request.execute("my/path")
          end.should raise_error(ConveyClient::RequestError)
        end
      end
    end

    describe "without a cache" do
      before do
        FakeWeb.register_uri(:get, "http://test.convey.io/api/my/path",
                             :body => "response content")
      end

      it "should send a http request but not cache the response" do
        ConveyClient::Request.execute("my/path").should == "response content"
        ConveyClient.cached_response("my/path").should be_nil
      end
    end

    describe "with a cache" do
      before do
        ConveyClient.setup do |config|
          config.subdomain = "test"
          config.use_cache(:memory, 86400)
        end
      end

      describe "when the path is cached" do
        it "should return the cached response" do
          ConveyClient.cache("my/path", "content")
          ConveyClient::Request.execute("my/path").should == "content"
        end
      end

      describe "when the path is not cached" do
        before do
          FakeWeb.register_uri(:get, "http://test.convey.io/api/my/path",
                               :body => "response content")
        end

        it "should send a http request and cache the response" do
          ConveyClient::Request.execute("my/path").should == "response content"
          ConveyClient.cached_response("my/path").should == "response content"
        end
      end
    end
  end
end
