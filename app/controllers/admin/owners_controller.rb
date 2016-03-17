class Admin::OwnersController < AdminController
  before_action :set_owner, only: [:show, :recalculate, :update_contacts, :fake_notification]

  def index
    @owners = Kaminari.paginate_array(Owner.all).page(params[:page])
  end

  def show
  end

  def update_contacts
    handle_admin_action(Admin::Owners::UpdateContacts.new(@owner), admin_owners_path)
  end

  def recalculate
    handle_admin_action(Admin::Owners::Recalculate.new(@owner), admin_owners_path)
  end

  def fake_notification
    handle_admin_action(Admin::Owners::FakeNotification.new(@owner), admin_owner_path(@owner.mkey))
  end

  private

  def set_owner
    @owner = Owner.new(params[:id])
  end
end
