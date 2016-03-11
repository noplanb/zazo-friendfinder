class ResqueWorker::ScoreRecalculation
  @queue = :update_contacts

  def self.perform(owner_mkey)
    WriteLog.info(self, "resque job was executed for owner_mkey=#{owner_mkey}")
    Owner.new(owner_mkey).contacts.each { |c| c.scores.destroy_all }
    Score::CalculationByOwner.new(owner_mkey).do
  end
end
