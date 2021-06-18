class Person < ApplicationRecord
  has_many :analyses, dependent: :destroy

  validates :full_name, presence: true

  def assign_fields(fields)
    fields.each do |k, v|
      splitten_key = k.split('_')
      p_key = splitten_key.shift
      c_key = splitten_key.join('_')
      metadata[p_key] = {} unless metadata.key?(p_key)
      metadata[p_key][c_key] = v
    end
  end
end
