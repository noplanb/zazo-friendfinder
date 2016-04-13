module JsonResponseHelper
  def json_response
    JSON.parse(response.body)
  end
end

RSpec.configure do |config|
  config.include JsonResponseHelper, type: :controller
end
