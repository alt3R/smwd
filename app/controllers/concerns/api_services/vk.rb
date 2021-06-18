module ApiServices
  module VK
    extend ActiveSupport::Concern

    API_VERSION = '5.131'.freeze
    ACCESS_TOKEN = -> { EncryptionService.decrypt(Current.visitor.metadata.dig('vk', 'access_token')) }

    def vk_access_token
      resp = {}
      resp['vk'] = send_request(
        'https://oauth.vk.com/access_token' \
        "?client_id=#{Rails.application.credentials.vk[:client_id]}" \
        "&client_secret=#{Rails.application.credentials.vk[:client_secret]}" \
        "&redirect_uri=#{heroku_url}/auth-in-vk" \
        "&code=#{vk_auth_params[:code]}"
      )
      resp
    end

    def vk_attrs
      get_vk_countries
      get_vk_regions
      get_vk_cities
      get_vk_users
    end

    def get_vk_countries
      return @vk_countries = [] unless @person&.country

      result = send_request(
        'https://api.vk.com/method/database.getCountries' \
        "?code=#{@person.country}" \
        "&access_token=#{ACCESS_TOKEN.call}" \
        "&v=#{API_VERSION}"
      )
      @vk_countries = if result.dig(:response, :items)
                        result[:response][:items].map { |item| [item[:title], item[:id]] }
                      else
                        []
                      end
    end

    def get_vk_regions
      return @vk_regions = [] if !@person&.region || !@person&.metadata&.dig('vk', 'country_id')

      addr = "https://api.vk.com/method/database.getRegions?country_id=#{@person.metadata.dig('vk', 'country_id')}"
      opts = URI.encode_www_form('q' => @person.region, 'access_token' => ACCESS_TOKEN.call, 'v' => API_VERSION)
      result = send_request("#{addr}&#{opts}")
      @vk_regions = if result.dig(:response, :items)
                      result[:response][:items].map { |item| [item[:title], item[:id]] }
                    else
                      []
                    end
    end

    def get_vk_cities
      return @vk_cities = [] if !@person&.city || !@person&.metadata&.dig('vk', 'country_id')

      addr = "https://api.vk.com/method/database.getCities?country_id=#{@person.metadata.dig('vk', 'country_id')}"
      attrs = []
      attrs << ['region_id', @person.metadata.dig('vk', 'region_id')] if @person.metadata.dig('vk', 'region_id')
      attrs += [['q', @person.city], ['access_token', ACCESS_TOKEN.call], ['v', API_VERSION]]
      opts = URI.encode_www_form(attrs)

      result = send_request("#{addr}&#{opts}")
      @vk_cities = if result.dig(:response, :items)
                     result[:response][:items].map { |item| [item[:title], item[:id]] }
                   else
                     []
                   end
    end

    def get_vk_users
      return @vk_users = [] unless @person&.full_name

      addr = 'https://api.vk.com/method/users.search'
      attrs = [['q', @person.full_name]]
      attrs << ['city', @person.metadata.dig('vk', 'city_id')] if @person.metadata.dig('vk', 'city_id')
      attrs << ['country', @person.metadata.dig('vk', 'country_id')] if @person.metadata.dig('vk', 'country_id')
      if @person.birthday
        attrs << [['birth_day', @person.birthday.day], ['birth_month', @person.birthday.month],
                  ['birth_year', @person.birthday.year]]
      end
      attrs += [['access_token', ACCESS_TOKEN.call], ['v', API_VERSION]]
      opts = URI.encode_www_form(attrs)

      result = send_request("#{addr}?#{opts}")
      @vk_users = if result.dig(:response, :items)
                    result[:response][:items].map do |item|
                      ["#{item[:first_name]} #{item[:last_name]}", item[:id]]
                    end
                  else
                    []
                  end
    end

    def vk_params
      params.require(:person).permit(:vk_user_id, :vk_country_id, :vk_region_id, :vk_city_id)
    end
  end
end
