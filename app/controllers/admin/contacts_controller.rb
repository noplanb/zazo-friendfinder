class Admin::ContactsController < AdminController
  before_action :set_contact, only: [:show, :recalculation]

  def index
    @contacts = Contact.all.page params[:page]
  end

  def show
  end

  def recalculation
    @contact.scores.each &:destroy
    Score::CalculationByContact.new(@contact).do
    redirect_to admin_contact_path
  end

  private

  def set_contact
    @contact = Contact.find params[:id]
  end
end
