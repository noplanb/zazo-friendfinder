class Vector::Cell < Cell::Concept
  class Table < Cell::Concept
    def show
      render
    end

    private

    def vectors
      model
    end
  end

  property :name, :value, :additions

  def table_row
    render :table_row
  end
end
