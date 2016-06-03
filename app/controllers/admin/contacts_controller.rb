class Admin::ContactsController < AdminController
  before_action :set_contact, only: [:show, :update_info, :recalculate]

  def index
    @contacts = Contact.order(:id).with_notifications.page(params[:page])
  end

  def show
  end

  def update_info
    handle_admin_action(Admin::Contacts::UpdateInfo.new(@contact), admin_contact_path)
  end

  def recalculate
    handle_admin_action(Admin::Contacts::Recalculate.new(@contact), admin_contact_path)
  end

  private

  def set_contact
    @contact = Contact.find(params[:id])
  end
end
