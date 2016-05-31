class Admin::Settings::Update < Admin::Settings
  attr_reader :params

  def initialize(params)
    @params = params.require(:settings).permit(self.class.setting_keys)
  end

  def do
    update_bool_settings(self.class.setting_keys_by_type(:bool))
    update_array_settings(self.class.setting_keys_by_type(:array))
    [true, 'Settings was updated']
  end

  private

  def update_bool_settings(keys)
    keys.each { |key| ::Settings[key] = params[key] == '1' ? true : false }
  end

  def update_array_settings(keys)
    keys.each { |key| ::Settings[key] = (params[key] || '').split(',') }
  end
end
