class ApplicationController < ActionController::Base
  include ActionController::Cookies
  include Visitors
  include ApiServices::Base
  include ApiClient
  include ApplicationHelper
end
