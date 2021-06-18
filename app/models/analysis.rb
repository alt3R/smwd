class Analysis < ApplicationRecord
  include ApiClient
  include Analyzers::VK

  belongs_to :person

  before_create :analyze

  def analyze
    run_vk_analyze if person&.metadata&.dig('vk', 'user_id')
  end
end
