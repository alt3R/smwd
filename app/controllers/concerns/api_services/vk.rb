module ApiServices
  module VK
    extend ActiveSupport::Concern

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
  end
end
