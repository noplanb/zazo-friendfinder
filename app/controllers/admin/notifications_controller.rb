class Admin::NotificationsController < AdminController
  before_action :set_notification, only: :show

  def index
    @notifications = Notification.all.page(params[:page])
  end

  def show
  end

  private

  def set_notification
    @notification = Notification.find_by_nkey(params[:id])
    @notification = Notification.find(params[:id]) unless @notification
  end
end
