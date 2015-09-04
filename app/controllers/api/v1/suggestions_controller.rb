class Api::V1::SuggestionsController < ApplicationController
  def index
    render json: { hello: :world }
  end
end
