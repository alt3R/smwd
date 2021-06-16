# frozen_string_literal: true

module ApiClient
  extend ActiveSupport::Concern

  SIGHTENGINE_API_URI = 'https://api.sightengine.com/1.0/check.json'
  SIGHTENGINE_API_USER = Rails.application.credentials.sightengine[:user]
  SIGHTENGINE_API_SECRET = Rails.application.credentials.sightengine[:secret]

  SOCIAL_SEARCHER_API_URI = 'https://api.social-searcher.com/v2/search'
  SOCIAL_SEARCHER_API_KEY = Rails.application.credentials.social_searcher[:key]

  def send_request(addr, opts = nil, type: :json, method: 'get')
    uri = URI(addr)
    request = "Net::HTTP::#{method.capitalize}".constantize.new(uri)
    request['Content-Type'] = 'application/json'
    request.body = opts.to_json if opts.present?
    response = Net::HTTP.start(uri.hostname) { |http| http.request(request) }
    return standard(response.body) if type == :standard

    json(response.body)
  end

  def list_of_users(username); end
  
  def find_weapon; end

  def json(body)
    JSON.parse(body).deep_symbolize_keys
  end

  def standard(body)
    body
  end
end
