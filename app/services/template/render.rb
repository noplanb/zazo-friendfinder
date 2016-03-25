class Template::Render
  VIEWS_PATH = 'app/views'

  attr_reader :template

  def initialize(template)
    @template = template
  end

  def content
    view.render(render_attrs)
  end

  private

  def view
    ActionView::Base.new(VIEWS_PATH, { data: template.view_data }, ActionController::Base.new)
  end

  def render_attrs
    { file: template.view_path }
  end
end
