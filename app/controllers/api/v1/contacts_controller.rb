class Api::V1::ContactsController < ApplicationController
  def create
    if manager.do
      render json: { status: :success }
    else
      render status: :unprocessable_entity, json: { status: :failure, errors: manager.validator.errors.messages }
    end
  end

  private

  def manager
    @manager ||= Contact::AddContacts.new(current_user, contacts_params)
  end

  def contacts_params
    params
  end
end
