class Owner::Cell < Cell::Concept
  ATTRIBUTES = [:mkey, :unsubscribed?, :contacts, :not_proposed_contacts, :other_services]

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
      show_not_proposed? ^ reverse ? 'Not proposed contacts' : 'Contacts'
    end

    def contacts
      show_not_proposed? ? owner.not_proposed_contacts : owner.contacts
    end

    def switch_contacts_link(css_class)
      params = show_not_proposed? ? {} : { show: 'not_proposed' }
      link_to(contacts_title(true), admin_owner_path(owner.mkey, params), class: css_class)
    end

    def recalculate_contacts_link(css_class)
      link_to('Recalculate contacts', recalculate_admin_owner_path(owner.mkey), class: css_class, method: :post, data: { confirm: 'Are you sure?' })
    end
  end

  class Table < Cell::Concept
    def show
      render
    end

    private

    def owners
      model
    end
  end

  property :mkey, :unsubscribed?

  def show
    render
  end

  def table_row
    render :table_row
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

  def notifications_count
    model.notifications.count
  end

  def other_services
    admin_link + ' | ' + renotification_link
  end

  def admin_link
    link_to('admin', "#{Figaro.env.admin_base_url}/users?user_id_or_mkey=#{mkey}")
  end

  def renotification_link
    link_to('renotification', "#{Figaro.env.renotification_base_url}/users/#{mkey}")
  end

  def link_to_owner
    link_to(mkey, admin_owner_path(mkey))
  end
end

