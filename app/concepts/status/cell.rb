class Status::Cell < Cell::Concept
  def show
    render
  end

  private

  def items
    [ owners_stats,
      contacts_stats,
      notifications_by_state(:in_queue),
      notifications_by_state(:sent),
      notifications_by_state(:canceled),
      notifications_by_state(:error) ]
  end

  def owners_stats
    { text: Owner.all.count,
      desc: 'owners' }
  end

  def contacts_stats
    { text: Contact.all.count,
      desc: 'contacts' }
  end

  def notifications_by_state(state)
    { text: Notification.by_state(state == :in_queue ? nil : state).count,
      desc: state.to_s,
      unit: 'nts.' }
  end
end
