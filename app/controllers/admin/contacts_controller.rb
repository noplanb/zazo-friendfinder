class Admin::ContactsController < AdminController
  before_action :set_contact, only: [:show, :update_info, :recalculate]

  def index
    @contacts = Contact.all.page(params[:page])
  end

  def show
  end

  def update_info
    Contact::SetZazoInfoByContact.new(@contact).do
    redirect_to(admin_contact_path, notice: 'Contact info (zazo id/mkey) was updated')
  end

  def recalculate
    Score::CalculationByContact.new(@contact).do
    redirect_to(admin_contact_path, notice: 'Score was recalculated')
  end

  private

  def set_contact
    @contact = Contact.find(params[:id])
  end
end
