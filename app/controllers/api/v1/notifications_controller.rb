class Api::V1::NotificationsController < ApiController
  before_action :set_notifications
  before_action :handle_action, only: %i(add ignore)

  def show
    handle_interactor(:process,
      Notifications::GetSerializedData.run(notification: @notifications.first))
  end

  def add
  end

  def ignore
  end

  private

  def handle_action
    handle_interactor(:process,
      Notifications::HandleAction.run(notifications: @notifications, action: params[:action],
                                      phone_number: params[:phone_number], caller: :api))
  end

  def set_notifications
    @notifications = handle_interactor(:data,
      Notifications::FindNotifications.run(nkey: params[:id]))
  end
end
