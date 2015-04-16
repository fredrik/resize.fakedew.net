require 'faraday'

class ImageFetcher
  def self.fetch(url, user=nil, password=nil)
    conn = Faraday::Connection.new
    conn.basic_auth(user, password) if user && password
    response = conn.get(url)
    return unless response.status == 200
    response.body
  end
end
