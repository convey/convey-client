require 'spec_helper'

describe ConveyClient::Item do
  before do
    @item = ConveyClient::Item.new({
      "id"         => "id",
      "name"       => "name",
      "bucket"     => "bucket-id",
      "template"   => "template-id",
      "attributes" => {
        "age" => {
          "value" => 28
        },
        "level" => {
          "value" => "blue"
        },
      }
    })
  end

  describe "core attributes" do
    it "should store the items id" do
      @item.id.should == "id"
    end

    it "should store the items name" do
      @item.name.should == "name"
    end

    it "should store the items bucket" do
      @item.bucket.should == "bucket-id"
    end

    it "should store the items template" do
      @item.template.should == "template-id"
    end
  end

  describe "accessing template attributes" do
    it "should provide methods for each attribute key" do
      @item.age.should == 28
      @item.level.should == "blue"
    end
  end
end
