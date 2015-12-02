class Admin::OwnersController < AdminController
  before_action :set_owner, only: :show

  def index
  end

  def show
  end

  private

  def set_owner
    @owner = Owner.new params[:id]
  end
end
