class DocumentationController < ActionController::Base
  http_basic_authenticate_with name: Figaro.env.http_basic_name,
                               password: Figaro.env.http_basic_password

  layout false
  before_action :check_file_exists

  def show
    render file: full_path.to_s
  end

  protected

  def check_file_exists
    Rails.logger.debug "Checking file: #{full_path}"
    render text: 'file not found', status: :not_found unless File.exist?(full_path)
  end

  def full_path
    path = params[:id]
    extname = params[:format] ? '.' + params[:format] : '.html'
    basename = File.basename(path, extname)
    Rails.root.join('doc', "#{basename}#{extname}")
  end
end
