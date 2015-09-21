class Api::V1::ContactsController < ApplicationController
  def create
    handle_with_manager Contact::AddContacts.new(current_user, params['contacts']) do
      Resque.enqueue UpdateNewContactsByOwnerWorker, current_user.mkey
    end
  end
end
