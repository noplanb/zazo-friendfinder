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

  def run_interactor(type, interactor, options = {})
    outcome = interactor.run(options)
    if outcome.valid?
      case type
        when :process then render json: { status: :success, data: outcome.result }
        else outcome.result
      end
    else
      render status: :unprocessable_entity, json: { status: :failure, errors: outcome.errors.messages }
    end
  end
end
