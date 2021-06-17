module ApplicationHelper
  def heroku_url
    "https://#{Rails.application.class.module_parent.name.downcase}.herokuapp.com"
  end
end
