module ServicesLinksHelper
  def services_links(mkey)
    return '' unless mkey
    "#{admin_link(mkey)} | #{renotification_link(mkey)}"
  end

  def admin_link(mkey)
    mkey && link_to('admin', "#{Figaro.env.admin_base_url}/users?user_id_or_mkey=#{mkey}")
  end

  def renotification_link(mkey)
    mkey && link_to('renotification', "#{Figaro.env.renotification_base_url}/users/#{mkey}")
  end

  def friendfinder_link(mkey)
    mkey && link_to(mkey, admin_owner_path(mkey))
  end
end
