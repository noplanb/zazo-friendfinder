module Contact::Extensions::Owners
  def owner
    @owner ||= Owner.new(owner_mkey)
  end
end
