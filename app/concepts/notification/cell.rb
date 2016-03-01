class Notification::Cell < Cell::Concept
  ATTRIBUTES = [:nkey, :kind, :contact, :state, :status, :category, :created_at, :updated_at]

  class Table < Cell::Concept
    def show
      render
    end

    private

    def notifications
      model
    end

    def disable_contact_link?
      !!options[:disable_contact_link]
    end
  end

  property :id, :nkey, :contact, :kind, :state, :status, :category, :created_at, :updated_at

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

  def contact
    disable_contact_link? ? model.contact.id : contact_link
  end

  def contact_link
    link_to model.contact.id, admin_contact_path(model.contact.id)
  end

  def disable_contact_link?
    !!options[:disable_contact_link]
  end
end
