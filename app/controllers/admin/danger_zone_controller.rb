class Admin::DangerZoneController < AdminController
  before_action :set_owner

  def drop_contacts
    handle_admin_action(Admin::Owners::DropContacts.new(@owner), admin_owner_path(@owner.mkey))
  end

  def drop_notifications
    handle_admin_action(Admin::Owners::DropNotifications.new(@owner), admin_owner_path(@owner.mkey))
  end

  def clear_statuses
    handle_admin_action(Admin::Owners::ClearContactsStatuses.new(@owner), admin_owner_path(@owner.mkey))
  end

  def mark_as_friend_randomly
    handle_admin_action(Admin::Owners::MarkAsFriendRandomly.new(@owner), admin_owner_path(@owner.mkey))
  end

  private

  def set_owner
    @owner = Owner.new(params[:id])
  end
end
