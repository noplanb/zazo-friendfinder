class Template
  attr_reader :view_data, :notification

  def initialize(notification)
    @notification = notification
    @view_data = ViewData.new(notification)
  end

  def view_path
    "templates/_#{notification.kind}_template"
  end
end
