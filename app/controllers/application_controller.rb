class ApplicationController < ActionController::Base
  include ActionController::Cookies
  include Visitors
  include ApiClient
  include ApiServices::Base
  include ApiServices::VK
  include ApplicationHelper
end
