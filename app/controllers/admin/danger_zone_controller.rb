class Admin::DangerZoneController < AdminController
  before_action :set_owner

  def drop_contacts
    @owner.contacts.destroy_all
    redirect_to admin_owner_path(@owner.mkey), alert: 'All contacts was destroyed'
  end

  def drop_notifications
    @owner.notifications.destroy_all
    redirect_to admin_owner_path(@owner.mkey), alert: 'All notifications was destroyed'
  end

  def clear_statuses
    handle_admin_action(Admin::Owners::ClearContactsStatuses.new(@owner), admin_owner_path(@owner.mkey))
  end

  private

  def set_owner
    @owner = Owner.new(params[:id])
  end
end
