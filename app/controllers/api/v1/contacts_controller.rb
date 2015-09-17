class Api::V1::ContactsController < ApplicationController
  def create
    handle_with_manager Contact::AddContacts.new(current_user, params['contacts']) do
      Contact::SetZazoIdAndMkeyByOwnerContacts.new(current_user.mkey).do_async { Score::CalculationByOwner.new(current_user.mkey).do }
    end
  end
end
