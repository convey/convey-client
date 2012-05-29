require 'spec_helper'

SINGLE_ITEM_RESPONSE = <<-ITEM
{"name":"First Item Name","id":"first-itemg-name","template":"first-item-template","bucket":"first-items","attributes":{"published_on":{"type":"date","value":"2012-04-27"},"content":{"type":"text","value":"<p>This is some content</p>"}}}
ITEM
MULTIPLE_ITEMS_RESPONSE = <<-ITEMS
[#{SINGLE_ITEM_RESPONSE},{"name":"Second Item Name","id":"second-itemg-name","template":"second-item-template","bucket":"second-items","attributes":{"published_on":{"type":"date","value":"2012-05-27"},"content":{"type":"text","value":"<p>This is second items content</p>"}}}]
ITEMS

describe ConveyClient::Items do
  before do
    ConveyClient.setup do |config|
      config.subdomain = "test"
      config.auth_token = nil
    end
  end

  describe ".find" do
    describe "when found" do
      before do
        ConveyClient::Request.stub!(:execute).and_return(SINGLE_ITEM_RESPONSE)
      end

      it "should return the found item" do
        item = ConveyClient::Items.find("id")
        item.name.should == "First Item Name"
      end
    end

    describe "when nothing is found" do
      before do
        ConveyClient::Request.stub!(:execute).and_return("[]")
      end

      it "should return nil" do
        ConveyClient::Items.find("id").should be_nil
      end
    end
  end

  describe ".all" do
    describe "when there is one item" do
      before do
        ConveyClient::Request.stub!(:execute).and_return(SINGLE_ITEM_RESPONSE)
      end

      it "should return an array of one" do
        ConveyClient::Items.all.length.should == 1
      end
    end

    describe "when there are multiple items" do
      before do
        ConveyClient::Request.stub!(:execute).and_return(MULTIPLE_ITEMS_RESPONSE)
        @items = ConveyClient::Items.all
      end

      it "should return an array" do
        @items.length.should == 2
      end

      it "should return the results in order" do
        @items[0].name.should == "First Item Name"
        @items[1].name.should == "Second Item Name"
      end
    end
  end

  describe ".in_bucket" do
    it "should create the appropriate request path" do
      ConveyClient::Request.should_receive(:execute).with("buckets/bucket-id/items").and_return("[]")
      ConveyClient::Items.in_bucket("bucket-id").to_a
    end
  end

  describe ".using_template" do
    it "should create the appropriate request path" do
      ConveyClient::Request.should_receive(:execute).with("templates/template-id/items").and_return("[]")
      ConveyClient::Items.using_template("template-id").to_a
    end
  end

  describe ".in_bucket_and_using_template" do
    it "should create the appropriate request path" do
      ConveyClient::Request.should_receive(:execute).with("buckets/bucket-id/templates/template-id/items").and_return("[]")
      ConveyClient::Items.in_bucket_and_using_template("bucket-id", "template-id").to_a
    end
  end

  describe "sorting" do
    it "should add the appropriate params to the request path" do
      ConveyClient::Request.should_receive(:execute).with("items?sort[key]=age&sort[dir]=asc").and_return("[]")
      ConveyClient::Items.all.sorted("age", "asc").to_a
    end
  end

  describe "querying" do
    it "should add the appropriate params to the request path" do
      ConveyClient::Request.should_receive(:execute).with("items?search[age][operator]==&search[age][value]=20").and_return("[]")
      ConveyClient::Items.all.where("age", "=", 20).to_a
    end
  end
end
