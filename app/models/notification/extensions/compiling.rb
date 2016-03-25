module Notification::Extensions::Compiling
  def compiled_content
    Template::Render.new(Template.new(self)).content
  end
end
