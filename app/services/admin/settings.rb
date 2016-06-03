class Admin::Settings
  ALLOWED_SETTINGS = {
    bool: [:fake_notifications_enabled,
           :mobile_notifications_enabled,
           :email_notifications_enabled,
           :notify_specific_owners_only],
    array: [:specific_owners]
  }

  def self.setting_keys
    ALLOWED_SETTINGS.inject([]) { |memo,(_,value)| memo + value }
  end

  def self.setting_keys_by_type(type)
    ALLOWED_SETTINGS[type]
  end
end
