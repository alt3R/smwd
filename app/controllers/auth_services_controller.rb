class AuthServicesController < ApplicationController

  include ApiServices::VK

  def vk
    redirect_to root_path and return if Current.visitor.metadata.dig('vk', 'access_token')
    return unless %w[code state].all? { |k| vk_auth_params.key?(k) }
    return unless vk_auth_params[:state] == Current.visitor.id

    resp = vk_access_token
    update_visitor(Current.visitor, resp) if resp['vk'].present?
    redirect_to root_path
  end

  private

  def vk_auth_params
    params.permit(:code, :state)
  end
end
