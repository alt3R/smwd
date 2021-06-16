# frozen_string_literal: true

module Visitors
  extend ActiveSupport::Concern

  included do
    before_action :init_visitor
  end

  def init_visitor
    Current.visitor = load_visitor || create_visitor
  end

  def load_visitor
    return if cookies.encrypted[:visitor].blank?
    return unless cookies.encrypted[:visitor].try(:[], :type) == 'Visitor'
    return unless cookies.encrypted[:visitor].try(:[], :id).is_a?(String)

    visitor = Visitor.find_by(id: cookies.encrypted[:visitor][:id])
    visitor = update_visitor(visitor) if visitor.present?
    visitor
  end

  def create_visitor
    return unless request.user_agent

    browser = Browser.new(request.user_agent, accept_language: request.env['HTTP_ACCEPT_LANGUAGE'])
    return if browser.bot? || /(wget|slurp|bot|crawler|spider)/.match(request.user_agent.downcase)

    visitor = Visitor.new
    visitor.online = Time.zone.now
    visitor = update_visitor(visitor)
    set_cookie(visitor.id)
    visitor
  end

  def update_visitor(visitor)
    visitor.metadata['user_agent'] = request.user_agent
    if request.headers['HTTP_ACCEPT'] && request.headers['HTTP_ACCEPT'] != '*/*'
      visitor.metadata['accept'] = request.headers['HTTP_ACCEPT']
    end
    visitor.metadata['accept_language'] = request.env['HTTP_ACCEPT_LANGUAGE']
    visitor.online_update
    visitor.save if visitor.changed?
    visitor
  end

  def set_cookie(visitor_id)
    cookies.encrypted[:visitor] = {
      value: { type: 'Visitor', id: visitor_id },
      expires: 3.years.from_now,
      httponly: true
    }
  end
end
