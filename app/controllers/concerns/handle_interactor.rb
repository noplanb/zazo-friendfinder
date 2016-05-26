module HandleInteractor
  extend ActiveSupport::Concern

  included do
    def handle_interactor(type, outcome)
      type, settings = Array.wrap(type)
      settings = default_interactor_settings(type).merge(settings || {})

      if outcome.valid?
        yield if block_given?
        handle_interactor_by_type(type, settings, outcome.result)
      else
        render status: :unprocessable_entity,
               json: { status: :failure, errors: outcome.errors.messages }
      end
    end

    private

    def handle_interactor_by_type(type, settings, result)
      case type
        when :render
          json = { status: :success }
          json.merge!(data: result) if settings[:result]
          render json: json
        when :result then result
        else nil
      end
    end

    def default_interactor_settings(type)
      case type
        when :render then { result: true }
        else {}
      end
    end
  end
end
