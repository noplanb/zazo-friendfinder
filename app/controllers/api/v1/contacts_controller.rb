class Api::V1::ContactsController < ApiController
  def create
    handle_with_manager Contact::ControllerManager::ValidateRawParams.new(current_user.mkey, params) do
      Resque.enqueue(ResqueWorker::AddContacts, current_user.mkey, params['contacts'])
    end
  end

  def add
    handle_with_manager Contact::ControllerManager::AddContacts.new(current_user.mkey, { 'added' => params['added'] })
  end

  def reject
    handle_with_manager Contact::ControllerManager::RejectContacts.new(current_user.mkey, { 'rejected' => params['rejected'] })
  end

  def recommend
    handle_with_manager Contact::ControllerManager::AddRecommendation.new(current_user.mkey, params['recommendations'])
  end
end
