class TemplatesController < ApplicationController
  def index
    @templates = Template.all
  end

  def new
    @template = Template.new
  end

  def edit
    @template = Template.find params[:id]
  end

  def create

  end

  def update

  end

  def destroy

  end

  private

  def templates_params
    params.require(:templates).permit(:name)
  end
end
