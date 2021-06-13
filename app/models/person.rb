class Person < ApplicationRecord
  after_initialize :defaults, unless: :new_record?

  validates :full_name, presence: true, if: -> { username.blank? }
  validates :username, presence: true, if: -> { full_name.blank? }

  def defaults
    (attribute_names - %w[id created_at updated_at]).each do |attribute_name|
      send("#{attribute_name}=", 'undefined') if send(attribute_name).blank?
    end
  end
end
