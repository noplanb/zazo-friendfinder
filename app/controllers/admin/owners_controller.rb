class Admin::OwnersController < AdminController
  before_action :set_owner, only: [:show, :recalculate]

  def index
    @owners = Kaminari.paginate_array(Owner.all).page(params[:page])
  end

  def show
  end

  def recalculate
    Resque.enqueue(ResqueWorker::ScoreRecalculation, @owner.mkey) if @owner.contacts.count > 0
    redirect_to(admin_owners_path, notice: "Recalculation for owner (#{@owner.mkey}) was started")
  end

  private

  def set_owner
    @owner = Owner.new(params[:id])
  end
end
