class Api::V1::ContactsController < ApiController
  def create
    handle_with_manager Contact::ControllerManager::ValidateRawParams.new(current_user.mkey, params) do
      Resque.enqueue(Contact::AddContactsWorker, current_user.mkey, params['contacts'])
    end
  end
end
