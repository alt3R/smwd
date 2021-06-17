class AuthServicesController < ApplicationController
  def vk
    return unless %w[code state].all? { |k| vk_auth_params.key?(k) }

    resp = {}
    resp['vk'] = send_request(
      'https://oauth.vk.com/access_token' \
      "?client_id=#{Rails.application.credentials.vk[:client_id]}" \
      "&client_secret=#{Rails.application.credentials.vk[:client_secret]}" \
      "&redirect_uri=#{heroku_url}/auth-in-vk" \
      "&code=#{vk_auth_params[:code]}"
    )
    update_visitor(Current.visitor, resp) if resp['vk'].present?
  end

  private

  def vk_auth_params
    params.permit(:code, :state)
  end
end
