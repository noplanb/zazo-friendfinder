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

  def handle_interactor(type_settings, interactor, &callback)
    Controllers::HandleApiInteractor.new(
      context: self, interactor: interactor,
      type_settings: type_settings, callback: callback).call do |handler|
      handler.render? ? render(handler.response) : handler.result
    end
  end
end
