class Api::V1::SuggestionsController < ApiController
  def index
    handle_with_manager(Api::Contact::GetSuggestions.new(current_user.mkey, {}))
  end

  def recommend
    handle_with_manager(Api::Contact::Recommend.new(current_user.mkey, params['recommendations']))
  end
end
