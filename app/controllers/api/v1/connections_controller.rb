class Api::V1::ConnectionsController < ApplicationController
  def create
    if manager.do
      render json: { status: :success }
    else
      render status: :unprocessable_entity, json: { status: :failure, errors: manager.validation.errors.messages }
    end
  end

  private

  def manager
    @manager ||= Connection::AddConnections.new(current_user, connections_params)
  end

  def connections_params
    params
  end
end
