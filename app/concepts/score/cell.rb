class Score::Cell < Cell::Concept
  class Table < Cell::Concept
    def show
      render
    end

    private

    def scores
      model
    end
  end

  property :name, :value

  def show
    render
  end

  def table_row
    render :table_row
  end
end
