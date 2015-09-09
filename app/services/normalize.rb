class Normalize
  def self.mobile(phone)
    GlobalPhone.normalize phone
  end

  def self.email(email)
    email.downcase
  end
end
