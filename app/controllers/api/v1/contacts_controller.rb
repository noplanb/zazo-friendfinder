class Api::V1::ContactsController < ApplicationController
  def create
    manager = Contact::AddContacts.new(current_user, contacts_params)
    if manager.do
      render json: { status: :success }
    else
      render status: :unprocessable_entity, json: { status: :failure, errors: manager.errors }
    end
  end

  private

  def contacts_params
    params['contacts']
  end
end
