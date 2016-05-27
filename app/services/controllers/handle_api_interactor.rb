class Controllers::HandleApiInteractor
  attr_reader :context, :interactor, :type, :settings, :callback,
              :response, :result

  def initialize(context:, interactor:, type_settings:, callback: nil)
    @context    = context
    @interactor = interactor
    @callback   = callback

    @type, @settings = Array.wrap(type_settings)
    @settings = default_settings(type).merge(@settings || {})
  end

  def call
    if interactor.valid?
      prepare_data_by_success_case
      log_data_by_case(:success) if settings[:logging_success]
      callback.call if callback
    else
      prepare_data_by_failure_case
      log_data_by_case(:failure) if settings[:logging_failure]
    end
    yield(self)
  end

  def render?
    !!response
  end

  private

  def prepare_data_by_success_case
    case type
      when :render
        @response = { status: :success }
        @response = response.merge(data: interactor.result) if settings[:result]
        @response = { json: response }
      when :result
        @result = interactor.result
      else nil
    end
  end

  def prepare_data_by_failure_case
    @response = {
      status: :unprocessable_entity,
      json: { status: :failure, errors: interactor.errors.messages }
    }
  end

  def log_data_by_case(status)
    _status       = "#{status};"
    _interactor   = "[#{interactor.class}]"
    _current_user = "current_user: #{context.current_user.mkey};"
    _response     = "response: #{response.to_json};"
    _inputs       = "inputs: #{interactor.inputs.to_json};"

    Zazo::Tools::Logger.info(context,
      "#{_interactor} #{_status} #{_current_user} #{_inputs} #{_response}")
  end

  def default_settings(type)
    case type
      when :render
        { result: true,
          logging_success: true,
          logging_failure: true }
      when :result
        { logging_failure: true }
      else {}
    end
  end
end
