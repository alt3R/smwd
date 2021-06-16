module ApplicationHelper

    def heroku_url
        web_url = `heroku info #{Rails.application.class.module_parent.name.downcase} | grep 'Web URL'`
        extracted_url = URI.extract(web_url, /http(s)/)
        extracted_url.first
    end

end
