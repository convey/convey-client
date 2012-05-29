require 'json'

module ConveyClient
  class Items
    include Enumerable

    attr_accessor :path, :sort_key, :sort_dir, :items, :search_params

    def initialize(path)
      self.path = path
      self.items = nil
      self.search_params = []
    end

    def sorted(key, dir)
      self.sort_key = key
      self.sort_dir = dir
      self
    end

    def where(key, operator, val)
      search_params << [ key, operator, val ]
      self
    end

    def each
      to_a
      items.each { |item| yield item }
    end

    def length
      to_a
      items.length
    end

    def to_a
      return items if items

      parse(ConveyClient::Request.execute(url))
      items
    rescue RequestError
      self.items = []
    end

    def [](index)
      to_a[index]
    end

    def self.find(item_id)
      new("items/#{item_id}").to_a.first
    end

    def self.all
      new("items")
    end

    def self.in_bucket(bucket_id)
      new("buckets/#{bucket_id}/items")
    end

    def self.using_template(template_id)
      new("templates/#{template_id}/items")
    end

    def self.in_bucket_and_using_template(bucket_id, template_id)
      new("buckets/#{bucket_id}/templates/#{template_id}/items")
    end

  private
    def parse(raw_items)
      parsed_items = JSON.parse(raw_items)
      if parsed_items.is_a?(Array)
        self.items = parsed_items.collect do |raw_item|
          Item.new(raw_item)
        end
      else
        self.items = [ Item.new(parsed_items) ]
      end
    end

    def url
      params = []

      if sort_key && sort_dir
        params << URI.encode("sort[key]=#{sort_key}")
        params << URI.encode("sort[dir]=#{sort_dir}")
      end

      search_params.each do |(key, operator, value)|
        params << URI.encode("search[#{key}][operator]=#{operator}&search[#{key}][value]=#{value}")
      end

      if params.any?
        "#{path}?#{params.join("&")}"
      else
        path
      end
    end
  end
end
