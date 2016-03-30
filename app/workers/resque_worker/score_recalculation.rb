class ResqueWorker::ScoreRecalculation
  @queue = :update_contacts

  def self.perform(owner_mkey)
    WriteLog.info(self, "resque job was executed for owner_mkey=#{owner_mkey}")
    owner = Owner.new(owner_mkey)
    owner.contacts.each { |c| c.scores.destroy_all }
    owner.contacts_actions.recalculate_scores
  end
end
