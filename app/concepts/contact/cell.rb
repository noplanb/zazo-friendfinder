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
           :total_score, :zazo_id, :expires_at

  def table_row
    render :table_row
  end
end
