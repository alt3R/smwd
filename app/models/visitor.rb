class Visitor < ApplicationRecord
  def online_update
    self.online = Time.zone.now if online < 1.minute.ago
  end
end
