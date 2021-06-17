class ApplicationController < ActionController::Base
  include ActionController::Cookies
  include Visitors
  include AuthServices
  include ApiClient
  include ApplicationHelper
end
