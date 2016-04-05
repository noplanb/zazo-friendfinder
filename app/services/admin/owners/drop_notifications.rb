class Admin::Owners::DropNotifications < Admin::Owners
  def do
    @owner.notifications.destroy_all
    [true, 'All notifications was destroyed']
  end
end
