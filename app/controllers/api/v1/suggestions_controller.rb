class Api::V1::SuggestionsController < ApiController
  def index
    render json: { status: :success, data: Contact::GetSuggestions.new(current_user.mkey).do }
  end

  def reject
    handle_with_manager Contact::ControllerManager::RejectSuggestion.new(current_user.mkey, { 'rejected' => params['rejected'] })
  end

  def recommend
    handle_with_manager Contact::ControllerManager::AddRecommendation.new(current_user.mkey, params['recommendations'])
  end
end
