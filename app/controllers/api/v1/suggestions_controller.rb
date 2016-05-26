class Api::V1::SuggestionsController < ApiController
  def index
    handle_interactor(:render,
      Contacts::GetSuggestions.run(owner: current_user))
  end

  def recommend
    handle_interactor([:render, result: false],
      Contacts::RecommendContact.run(owner: current_user, recommendations: params[:recommendations]))
  end
end
