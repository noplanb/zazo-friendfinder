class Owner::Cell < Cell::Concept
  include ServicesLinksHelper

  ATTRIBUTES = [:mkey, :unsubscribed?, :contacts, :not_proposed_contacts, :owner_links]

  class Contacts < Cell::Concept
    FILTER_MAP = {
      friends: :friends,
      not_friends: :not_friends,
      ignored: :ignored,
      added: :added,
      not_added: :not_added,
      not_ignored: :not_ignored,
      proposed: :proposed,
      not_proposed: :not_proposed,
      suggestible: :suggestible
    }

    def show
      render
    end

    private

    def owner
      model
    end

    def subtitle
      contacts_and_subtitle[:subtitle].empty? ?
        '' : "(#{contacts_and_subtitle[:subtitle][1..-1]})"
    end

    def contacts
      contacts_and_subtitle[:contacts]
    end

    def contacts_and_subtitle
      return @contacts_and_subtitle if @contacts_and_subtitle
      filter_methods = (options[:show] || '').split(',').map(&:to_sym)
      @contacts_and_subtitle = { contacts: owner.contacts, subtitle: '' }
      @contacts_and_subtitle = filter_methods.inject(@contacts_and_subtitle) do |memo, method|
        FILTER_MAP.key?(method) ?
          { contacts: memo[:contacts].send(FILTER_MAP[method]),
            subtitle: "#{memo[:subtitle]},#{method}" } : memo
      end
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

