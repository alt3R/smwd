class ApplicationController < ActionController::Base
  include ActionController::Cookies
  include Visitors

  before_action :init_auth_services

  def init_auth_services
    init_auth_in_vk
  end

  def init_auth_in_vk
    return if controller_name == 'auth_services' && action_name == 'vk'
    return if Current.visitor.metadata.dig('vk', 'access_token')

    redirect_to(auth_in_vk_path) && return
  end
end
