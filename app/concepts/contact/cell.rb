class Contact::Cell < Cell::Concept
  class Table < Cell::Concept
    def show
      render
    end

    private

    def contacts
      model
    end
  end

  property :id, :owner_mkey, :display_name,
           :zazo_id, :total_score, :expires_at,
           :vectors

  def table_row
    render :table_row
  end
end
