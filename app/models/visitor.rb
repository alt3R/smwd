class Visitor < ApplicationRecord

  after_find :verify_important_values!

  def online_update
    self.online = Time.zone.now if online < 1.minute.ago
  end

  def set_vk_attrs(opts)
    opts['vk']['expires_at'] = Time.zone.now.to_i + opts['vk']['expires_in'].to_i
    opts['vk']['access_token'] = EncryptionService.encrypt(opts['vk']['access_token'])
    metadata['vk'] = opts['vk']
  end

  def verify_important_values!
    verify_vk_attrs!
  end

  def verify_vk_attrs!
    return unless metadata['vk']
    metadata['vk'].delete('access_token') if metadata.dig('vk', 'expires_at').to_i <= Time.zone.now.to_i

  end
end
