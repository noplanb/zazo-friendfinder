class Admin::ContactsController < AdminController
  before_action :set_contact, only: [:show]

  def index
    @contacts = Contact.all
  end

  def show
  end

  private

  def set_contact
    @contact = Contact.find params[:id]
  end
end
