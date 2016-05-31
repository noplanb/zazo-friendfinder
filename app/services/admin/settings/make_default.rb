class Admin::Settings::MakeDefault < Admin::Settings
  def do
    destroy_settings
    [true, 'Settings was reseted']
  end

  private

  def destroy_settings
    self.class.setting_keys.each { |key| ::Settings.destroy(key) rescue false }
  end
end
