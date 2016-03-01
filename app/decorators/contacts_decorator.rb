class ContactsDecorator < Draper::Decorator
  delegate_all

  def first_name
    display_name.split(' ').first
  end

  def initials
    display_name.split(' ').map { |w| w[0] }.join
  end

  def vector_value
    vector = vectors.mobile.first
    vector = vectors.email.first unless vector
    vector = vectors.first unless vector
    vector && vector.value
  end
end
