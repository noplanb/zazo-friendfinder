class Suggestion::GetSuggestions
  attr_reader :current_user

  def initialize(current_user)
    @current_user = current_user
  end

  def do
    Hash.new
  end
end
