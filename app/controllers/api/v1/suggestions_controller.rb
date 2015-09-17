class Api::V1::SuggestionsController < ApplicationController
  def index
    render json: { status: :success, data: Contact::GetSuggestions.new(current_user).do }
  end

  def reject
    handle_with_manager Contact::RejectSuggestion.new(current_user, reject_params)
  end

  def recommend
    handle_with_manager Contact::AddRecommendation.new(current_user, recommendation_params)
  end

  private

  def reject_params
    params
  end

  def recommendation_params
    params['recommendations']
  end
end
