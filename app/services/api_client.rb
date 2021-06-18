# frozen_string_literal: true

module ApiClient
  SIGHTENGINE_API_URI = 'https://api.sightengine.com/1.0/check.json'
  SIGHTENGINE_API_USER = Rails.application.credentials.sightengine[:user]
  SIGHTENGINE_API_SECRET = Rails.application.credentials.sightengine[:secret]

  SOCIAL_SEARCHER_API_URI = 'https://api.social-searcher.com/v2/search'
  SOCIAL_SEARCHER_API_KEY = Rails.application.credentials.social_searcher[:key]

  def send_request(addr, opts = nil, type: :json, method: :get)
    uri = URI(addr)
    response = case method
               when :get
                 get_request(uri, opts)
               else
                 standard_request(uri, opts, method)
               end
    return standard(response.body) if type == :standard

    json(response.body)
  end

  def get_request(uri, opts)
    uri.query = URI.encode_www_form(opts) if opts.present?
    Net::HTTP.get_response(uri)
  end

  def standard_request(uri, opts, method)
    request = "Net::HTTP::#{method.capitalize}".constantize.new(uri)
    request['Content-Type'] = 'application/json'
    request.body = opts.to_json if opts.present?
    Net::HTTP.start(uri.hostname, uri.port) { |http| http.request(request) }
  end

  def json(body)
    JSON.parse(body).with_indifferent_access
  rescue JSON::ParserError
    nil
  end

  def standard(body)
    body
  end
end
