class Api::V1::SuggestionsController < ApplicationController
  def index
    render json: Suggestion::GetSuggestions(current_user).do
  end
end
