class Api::V1::SuggestionsController < ApplicationController
  def index
    render json: Contact::GetSuggestions.new(current_user).do
  end

  def reject

  end

  def recommend
    Contact::AddRecommendation.new(current_user, recommendation_params)
  end

  private

  def recommendation_params
    params
  end
end
