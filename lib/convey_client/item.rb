module ConveyClient
  class Item
    attr_accessor :id, :name, :bucket, :template, :attributes

    def initialize(raw_item)
      self.id = raw_item["id"]
      self.name = raw_item["name"]
      self.bucket = raw_item["bucket"]
      self.template = raw_item["template"]
      self.attributes = raw_item["attributes"]
    end

    def method_missing(method, *args, &block)
      super unless attributes.keys.include?(method.to_s)

      attributes[method.to_s]["value"]
    end
  end
end
