module Contact::Extensions::Owners
  def owner
    Owner.new(owner_mkey)
  end
end
