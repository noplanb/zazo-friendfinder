class Api::V1::ContactsController < ApiController
  before_action :set_contact, only: %i(show add ignore)
  before_action :handle_action, only: %i(add ignore)

  def show
    handle_interactor(:process,
      Contacts::GetSerializedData.run(contact: @contact))
  end

  def create
    # TODO: refactor with interactor
    handle_with_manager(Api::Contact::ValidateRawParams.new(current_user.mkey, params)) do
      Resque.enqueue(ResqueWorker::ImportContacts, current_user.mkey, params['contacts'])
    end
  end

  def add
  end

  def ignore
  end

  private

  def handle_action
    handle_interactor(:process,
      Contacts::HandleAction.run(contact: @contact, action: params[:action],
                                 phone_number: params[:phone_number], caller: :api))
  end

  def set_contact
    @contact = handle_interactor(:data,
      Contacts::FindContact.run(id: params[:id], owner: current_user))
  end
end
