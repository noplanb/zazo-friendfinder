class TemplatesController < ApplicationController
  before_action :set_template, only: [:edit, :update, :destroy]

  def index
    @templates = Template.all
  end

  def new
    @template = Template.new
  end

  def edit
  end

  def create
    @template = Template.new templates_params
    if @template.save
      redirect_to templates_path, notice: "Template (#{@template.kind},#{@template.category}) was created"
    else
      render :new
    end
  end

  def update
    if @template.update templates_params
      redirect_to templates_path, notice: "Template (#{@template.kind},#{@template.category}) was updated"
    else
      render :edit
    end
  end

  def destroy
    @template.destroy
    redirect_to templates_path
  end

  private

  def templates_params
    params.require(:template).permit(:kind, :category, :content)
  end

  def set_template
    @template = Template.find params[:id]
  end
end
