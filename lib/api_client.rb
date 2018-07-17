require 'logger'

class ApiClient
  include RestClient

  def initialize(logger=nil)
    @logger = (logger || ::Logger.new('results/api_client.log'))
    @logger.level = ::Logger::DEBUG
    RestClient.log = @logger
  end

  def get(url, headers={})
    return RestClient.get(url, headers)
  end

  def post(url, payload, headers={})
    return RestClient.post(url, payload, headers)
  end
end
