module Contact::OwnerExtension
  def owner
    Owner.new(owner_mkey)
  end
end
