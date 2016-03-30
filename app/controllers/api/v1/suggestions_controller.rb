class Api::V1::SuggestionsController < ApiController
  def index
    render json: { status: :success, data: Contact::GetSuggestions.new(current_user.mkey).do }
  end
end
