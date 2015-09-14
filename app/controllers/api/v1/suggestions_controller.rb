class Api::V1::SuggestionsController < ApplicationController
  def index
    render json: Contact::GetSuggestions.new(current_user).do
  end

  def reject

  end

  def recommend
    manager = Contact::AddRecommendation.new(current_user, recommendation_params)
    if manager.do
      render json: { status: :success }
    else
      render status: :unprocessable_entity, json: { status: :failure, errors: manager.errors.messages }
    end
  end

  private

  def recommendation_params
    params
  end
end
