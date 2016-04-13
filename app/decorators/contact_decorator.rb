class ContactDecorator < Draper::Decorator
  delegate_all

  def first_name
    display_name.split(' ').first
  end

  def initials
    display_name.gsub(/[^\w\s]+/, '').split(' ').map { |w| w[0] }.join[0..1]
  end

  def vector_value
    vector = vectors.mobile.first
    vector = vectors.email.first unless vector
    vector = vectors.first unless vector
    vector && vector.value
  end

  def status
    return 'added' if added?
    return 'ignored' if ignored?
    ''
  end

  def notification_status
    object.notifications.first.try(:status) || ''
  end
end
