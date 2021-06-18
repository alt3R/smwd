module Analyzers
  module VK
    extend ActiveSupport::Concern
    include ApiClient

    def run_vk_analyze
      return if metadata.dig('vk', person.metadata.dig('vk', 'user_id'))

      photo_urls = get_user_photos
      metadata['vk'] = Hash[person.metadata.dig('vk', 'user_id'), analyze_photos(photo_urls)]
    end

    def get_user_photos
      return [] unless person&.metadata&.dig('vk', 'user_id')

      result = send_request('https://api.vk.com/method/photos.getAll' \
        "?owner_id=#{person.metadata.dig('vk', 'user_id')}" \
        "&#{URI.encode_www_form([['access_token', ApiServices::VK::ACCESS_TOKEN.call],
                                 ['v', ApiServices::VK::API_VERSION]])}")
      if result.dig(:response, :items)
        result[:response][:items].map do |item|
          next unless item[:sizes]

          max_size = item[:sizes].max_by { |size| size[:height] + size[:width] }
          max_size[:url]
        end
      else
        []
      end
    end

    def analyze_photos(urls)
      urls.map do |url|
        result = send_request(
          "#{SIGHTENGINE_API_URI}" \
          "?#{URI.encode_www_form([
                                    %w[models wad],
                                    ['api_user', SIGHTENGINE_API_USER],
                                    ['api_secret', SIGHTENGINE_API_SECRET],
                                    ['url', url]
                                  ])}"
        )
        next unless result[:status] == 'success'
        next if result[:weapon] <= 0.1

        { photo_url: url, accuracy: result[:weapon] }
      end.compact.uniq
    end
  end
end
