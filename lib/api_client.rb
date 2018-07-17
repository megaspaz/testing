
class ApiClient
  include RestClient

  def initialize
  end

  def get(url, headers={})
    return RestClient.get(url, headers)
  end

  def post(url, payload, headers={})
    return RestClient.post(url, payload, headers)
  end
end
