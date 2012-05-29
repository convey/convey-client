require 'net/http'

module ConveyClient
  class Request
    attr_accessor :path

    def initialize(path)
      self.path = path
    end

    def self.execute(path)
      new(path).execute
    end

    def execute
      return ConveyClient.cached_response(path) if ConveyClient.cached?(path)

      response = Net::HTTP.get_response(url)
      if response.code.to_i == 200
        ConveyClient.cache(path, response.body)
        response.body
      else
        if ConveyClient.raise_request_errors
          raise ConveyClient::RequestError, "#{url} - #{response.code}"
        else
          "[]"
        end
      end
    end

    def url
      return @url unless @url.nil?

      full_url = ConveyClient.base_url + path

      if (auth_token = ConveyClient.auth_token)
        full_url += full_url.include?("?") ? "&" : "?"
        full_url += "token=#{auth_token}"
      end

      @url = URI.parse(full_url)
    end
  end
end
