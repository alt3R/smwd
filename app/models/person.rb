class Person < ApplicationRecord
  validates :full_name, presence: true, if: -> { username.blank? }
  validates :username, presence: true, if: -> { full_name.blank? }
end
