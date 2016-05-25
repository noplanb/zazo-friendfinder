class Api::V1::NotificationsController < ApiController
  before_action :set_notifications
  before_action :handle_action, only: %i(add ignore)

  def show
    render json: { status: :success,
                   data: NotificationSerializer.new(@notifications.first).serializable_hash }
  end

  def add
  end

  def ignore
  end

  private

  def handle_action
    run_interactor(:process, Notifications::HandleAction,
      notifications: @notifications, action: params[:action], caller: :api)
  end

  def set_notifications
    @notifications = run_interactor(:data, Notifications::FindNotifications, nkey: params[:id])
  end
end
