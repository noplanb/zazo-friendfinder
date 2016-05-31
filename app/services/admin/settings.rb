class Admin::Settings
  ALLOWED_SETTINGS = {
    bool: %i(fake_notifications_enabled notify_specific_owners_only),
    array: %i(specific_owners)
  }

  def self.setting_keys
    ALLOWED_SETTINGS.inject([]) { |memo,(_,value)| memo + value }
  end

  def self.setting_keys_by_type(type)
    ALLOWED_SETTINGS[type]
  end
end
