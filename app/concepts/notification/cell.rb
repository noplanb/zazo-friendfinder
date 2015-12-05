class Notification::Cell < Cell::Concept
  class Table < Cell::Concept
    def show
      render
    end

    private

    def notifications
      model
    end
  end

  property :nkey, :kind, :state,
           :status, :category

  def show
    render
  end

  def table_row
    render :table_row
  end
end
