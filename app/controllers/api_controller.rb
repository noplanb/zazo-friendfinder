class ApiController < ApplicationController
  include Authentication

  def handle_with_manager(manager)
    if manager.do
      yield if block_given?
      manager.log_messages(:success)
      render json: { status: :success }.merge(manager.data)
    else
      manager.log_messages(:failure)
      render status: :unprocessable_entity, json: { status: :failure, errors: manager.errors }
    end
  end

  def handle_interactor(type, outcome)
    if outcome.valid?
      case type
        when :process
          render json: { status: :success, data: outcome.result }
        when :callback
          yield if block_given?
          render json: { status: :success }
        else outcome.result
      end
    else
      render status: :unprocessable_entity, json: { status: :failure, errors: outcome.errors.messages }
    end
  end
end
