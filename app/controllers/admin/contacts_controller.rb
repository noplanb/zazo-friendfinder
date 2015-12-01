class Admin::ContactsController < AdminController
  def index
    @contacts = Contact.all
  end

  def show
  end
end
