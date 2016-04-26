module Contact::Extensions::Vectors
  def phone_numbers
    vectors.mobile.pluck(:value)
  end

  def emails
    vectors.email.pluck(:value)
  end
end
