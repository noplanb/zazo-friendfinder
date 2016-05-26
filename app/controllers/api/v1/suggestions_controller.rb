class Api::V1::SuggestionsController < ApiController
  def index
    handle_interactor(:process,
      Contacts::GetSuggestions.run(owner: current_user))
  end

  def recommend
    handle_interactor(:process,
      Contacts::RecommendContact.run(owner: current_user, recommendations: params[:recommendations]))
  end
end
