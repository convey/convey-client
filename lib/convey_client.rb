require 'moneta'
require 'convey_client/item'
require 'convey_client/items'
require 'convey_client/request'
require 'convey_client/request_error'

module ConveyClient
  class << self
    attr_accessor :config
  end

  def self.setup
    self.config = Configuration.new
    yield(config)
  end

  def self.base_url
    "http://#{config.subdomain}.convey.io/api/"
  end

  def self.cached?(key)
    return false unless config.cache

    !config.cache[key].nil? && !config.cache[key].empty?
  end

  def self.cached_response(key)
    return unless cached?(key)

    config.cache[key]
  end

  def self.cache(key, content)
    return unless config.cache

    options = {}
    options[:expires_in] = config.cache_timeout if config.cache_timeout
    config.cache.store(key, content, options)
  end

  def self.auth_token
    config.auth_token
  end

  def self.subdomain
    config.subdomain
  end

  def self.raise_request_errors
    config.raise_request_errors
  end

  class Configuration
    attr_accessor :subdomain, :auth_token, :cache, :cache_timeout,
                  :raise_request_errors

    def use_cache(method, timeout = nil, options={})
      timeout, options = nil, timeout if timeout.is_a?(Hash)

      klass = method.to_s.split('_').collect { |e| e.capitalize }.join
      Moneta.autoload(klass.to_sym, "moneta/#{method}")
      self.cache = Moneta.const_get(klass).new(options)
      self.cache_timeout = timeout
    end
  end
end
