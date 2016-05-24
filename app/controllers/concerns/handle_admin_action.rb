module HandleAdminAction
  def handle_admin_action(service, redirect_path = admin_owners_path)
    status, message = service.do
    secure_redirect_to(redirect_path, (status ? :notice : :alert ) => message)
  end
end
