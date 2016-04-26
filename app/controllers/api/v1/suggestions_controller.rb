class Api::V1::SuggestionsController < ApiController
  def index
    render json: { status: :success, data: Contact::GetSuggestions.new(current_user.mkey).do }
  end

  def recommend
    handle_with_manager(Api::Contact::Recommend.new(current_user.mkey, params['recommendations']))
  end
end
