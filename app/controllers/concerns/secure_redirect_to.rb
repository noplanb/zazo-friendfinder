module SecureRedirectTo
  def secure_redirect_to(relative_path, options = {})
    if %w(production staging).include?(Rails.env)
      redirect_to("https://#{request.domain}#{relative_path}", options)
    else
      redirect_to(relative_path, options)
    end
  end
end
