module HandleWithManager
  def handle_with_manager(manager)
    if manager.do
      yield if block_given?
      manager.log_messages :success
      render json: { status: :success }
    else
      manager.log_messages :failure
      render status: :unprocessable_entity, json: { status: :failure, errors: manager.errors }
    end
  end
end
