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
    @template = Template.new templates_params
    @template.save ? redirect_to(templates_path) : render(:new)
  end

  def update

  end

  def destroy

  end

  private

  def templates_params
    params.require(:template).permit(:kind, :category, :content)
  end
end
