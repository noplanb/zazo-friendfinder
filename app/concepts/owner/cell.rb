class Owner::Cell < Cell::Concept
  include ServicesLinksHelper

  ATTRIBUTES = [:mkey, :unsubscribed?, :contacts, :not_proposed_contacts, :owner_links]

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
      show_not_proposed? ? owner.contacts.not_proposed : owner.contacts
    end

    def switch_contacts_link(css_class)
      params = show_not_proposed? ? {} : { show: 'not_proposed' }
      link_to(contacts_title(true), admin_owner_path(owner.mkey, params), class: css_class)
    end

    def fake_notification_link(css_class)
      link_to('Fake notification', fake_notification_admin_owner_path(owner.mkey), class: css_class, method: :post, data: { confirm: 'Are you sure?' })
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
    model.contacts.not_proposed.count
  end

  def notifications_count
    model.notifications.count
  end

  def owner_link
    friendfinder_link(mkey)
  end

  def owner_links
    services_links(mkey)
  end
end

