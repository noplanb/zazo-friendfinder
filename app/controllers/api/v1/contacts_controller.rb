class Api::V1::ContactsController < ApplicationController
  def create
    handle_with_manager Contact::AddContacts.new(current_user, contacts_params) do
      Contact::SetZazoIdAndMkeyByOwnerContacts.new(current_user.mkey).do_async { Score::CalculationByOwner.new(current_user.mkey).do }
    end
  end

  private

  def contacts_params
    params['contacts']
  end
end
