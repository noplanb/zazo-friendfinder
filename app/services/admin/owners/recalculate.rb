class Admin::Owners::Recalculate < Admin::Owners
  def do
    if owner.contacts.count > 0
      Resque.enqueue(ResqueWorker::ScoreRecalculation, owner.mkey)
      [true, "Recalculation for owner (#{@owner.mkey}) was started"]
    else
      [false, 'No contacts to recalculate']
    end
  end
end
