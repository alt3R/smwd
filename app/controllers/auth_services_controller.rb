class AuthServicesController < ApplicationController
  def vk; end

  private

  def vk_auth_params
    params.permit(:code, :state)
  end
end
