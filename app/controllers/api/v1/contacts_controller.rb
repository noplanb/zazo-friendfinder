class Api::V1::ContactsController < ApiController
  def show
    handle_with_manager(Api::Contact::GetInfo.new(current_user.mkey, params))
  end

  def create
    handle_with_manager(Api::Contact::ValidateRawParams.new(current_user.mkey, params)) do
      Resque.enqueue(ResqueWorker::ImportContacts, current_user.mkey, params['contacts'])
    end
  end

  def add
    handle_with_manager(Api::Contact::Add.new(current_user.mkey, params))
  end

  def ignore
    handle_with_manager(Api::Contact::Ignore.new(current_user.mkey, params))
  end
end
