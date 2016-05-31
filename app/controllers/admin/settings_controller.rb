class Admin::SettingsController < AdminController
  def index
    if request.delete?
      handle_admin_action(Admin::Settings::MakeDefault.new, admin_settings_path)
    end
  end

  def create
    handle_admin_action(Admin::Settings::Update.new(params), admin_settings_path)
  end
end
