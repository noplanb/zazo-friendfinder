module Contact::Extensions::Owner
  def owner
    Owner.new(owner_mkey)
  end
end
