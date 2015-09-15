class Api::V1::ContactsController < ApplicationController
  def create
    handle_with_manager Contact::AddContacts.new(current_user, contacts_params)
  end

  private

  def contacts_params
    params['contacts']
  end
end
