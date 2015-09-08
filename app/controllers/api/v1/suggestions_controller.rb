class Api::V1::SuggestionsController < ApplicationController
  def index
    render json: Suggestion::GetSuggestions.new(current_user).do
  end
end
