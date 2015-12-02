class Owner::Cell < Cell::Concept
  ATTRIBUTES = [ :mkey, :unsubscribed?, :contacts, :not_proposed_contacts, :other_services ]

  class Contacts < Cell::Concept
    def show
      render
    end

    private

    def owner
      model
    end

    def show_not_proposed?
      options[:show] == 'not_proposed'
    end

    def contacts_title(reverse = false)
      show_not_proposed? ^ reverse ? 'Not proposed contacts' : 'All contacts'
    end

    def contacts
      show_not_proposed? ? owner.not_proposed_contacts : owner.contacts
    end

    def switch_contacts_link(css_class)
      params = show_not_proposed? ? {} : { show: 'not_proposed' }
      link_to contacts_title(true), admin_owner_path(owner.mkey, params), class: css_class
    end
  end

  property :mkey, :unsubscribed?

  def show
    render
  end

  private

  def value(attr)
    respond_to?(attr, true) ? send(attr) : model.send(attr)
  end

  def contacts
    model.contacts.count
  end

  def not_proposed_contacts
    model.not_proposed_contacts.count
  end

  def other_services
    statistics_link + ' | ' + renotification_link
  end

  def statistics_link
    link_to 'statistics', "#{Figaro.env.statistics_api_base_url}/users?user_id_or_mkey=#{mkey}"
  end

  def renotification_link
    link_to 'renotification', "#{Figaro.env.renotification_base_url}/users/#{mkey}"
  end
end

