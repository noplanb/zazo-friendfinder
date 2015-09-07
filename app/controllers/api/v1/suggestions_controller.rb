class Api::V1::SuggestionsController < ApplicationController
  def index
    render json: Connection::GetSuggestions(current_user).do
  end
end
