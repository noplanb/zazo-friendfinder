class Contact::Cell < Cell::Concept
  ATTRIBUTES = [:owner_mkey, :display_name, :zazo_id,:zazo_mkey, :total_score,
                :expires_at, :additions, :notified?, :created_at, :updated_at]

  class Table < Cell::Concept
    def show
      render
    end

    private

    def contacts
      model
    end

    def disable_link_to_owner?
      !!options[:disable_link_to_owner]
    end
  end

  property :id, :display_name, :zazo_id,
           :total_score, :expires_at, :vectors

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

  def owner_mkey
    disable_link_to_owner? ? model.owner_mkey : link_to_owner
  end

  def link_to_owner
    link_to model.owner_mkey, admin_owner_path(model.owner_mkey)
  end

  def disable_link_to_owner?
    !!options[:disable_link_to_owner]
  end
end
