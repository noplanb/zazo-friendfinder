class Api::V1::ContactsController < ApplicationController
  def create
    handle_with_manager Contact::AddContacts.new(current_user, contacts_params) do
      Score::CalculationByOwner.new(current_user.mkey).do_async
    end
  end

  private

  def contacts_params
    params['contacts']
  end
end
