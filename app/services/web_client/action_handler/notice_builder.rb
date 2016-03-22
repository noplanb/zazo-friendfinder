class WebClient::ActionHandler::NoticeBuilder
  attr_reader :object

  def self.deserialize(json)
    data = JSON.parse(json).symbolize_keys.slice(:status, :title, :description)
    data.size == 3 ? new(nil, nil, nil).instance_variable_set(:'@object', data) : {}
  rescue JSON::ParserError
    {}
  end

  def initialize(status, title_key, description_key, additions = {})
    @object = {
      status: status,
      title: I18n.t("web_client.notifications.title.#{title_key}", additions),
      description: I18n.t("web_client.notifications.description.#{description_key}", additions)
    }
  end

  def status
    object[:status]
  end

  def title
    object[:title]
  end

  def description
    object[:description]
  end

  def as_json
    object.to_json
  end

  def inspect
    object.inspect
  end
end
