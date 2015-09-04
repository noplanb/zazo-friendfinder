class Api::V1::ConnectionsController < ApplicationController
  def create
    if manager.create
      render json: { status: :success }
    else
      render status: :unprocessable_entity, json: { status: :failure, errors: manager.validation.errors.messages }
    end
  end

  private

  def manager
    @manager ||= Connection::AddConnections.new(connections_params)
  end

  def connections_params
    params
  end
end
