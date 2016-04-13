class Api::V1::ContactsController < ApiController
  def show
    handle_with_manager Contact::ControllerManager::GetInfo.new(current_user.mkey, params)
  end

  def create
    handle_with_manager Contact::ControllerManager::ValidateRawParams.new(current_user.mkey, params) do
      Resque.enqueue(ResqueWorker::ImportContacts, current_user.mkey, params['contacts'])
    end
  end

  def add
    handle_with_manager Contact::ControllerManager::AddContacts.new(current_user.mkey, params)
  end

  def ignore
    handle_with_manager Contact::ControllerManager::IgnoreContacts.new(current_user.mkey, params)
  end
end
