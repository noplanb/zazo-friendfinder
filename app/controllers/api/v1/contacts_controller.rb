class Api::V1::ContactsController < ApiController
  before_action :set_contact, except: :create
  before_action :handle_action, only: %i(add ignore)

  def show
    handle_interactor(:render,
      Contacts::GetContactData.run(contact: @contact))
  end

  def create
    handle_interactor([:render, result: false],
      Contacts::ValidateRawParams.run(contacts: params[:contacts])) do
      Resque.enqueue(ResqueWorker::ImportContacts, current_user.mkey, params[:contacts])
    end
  end

  def add
  end

  def ignore
  end

  private

  def handle_action
    handle_interactor(:render,
      Contacts::HandleAction.run(contact: @contact, action: params[:action],
                                 phone_number: params[:phone_number], caller: :api))
  end

  def set_contact
    @contact = handle_interactor(:result,
      Contacts::FindContact.run(id: params[:id], owner: current_user))
  end
end
