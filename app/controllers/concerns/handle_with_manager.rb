module HandleWithManager
  def handle_with_manager(manager)
    if manager.do
      render json: { status: :success }
    else
      render status: :unprocessable_entity, json: { status: :failure, errors: manager.errors }
    end
  end
end
