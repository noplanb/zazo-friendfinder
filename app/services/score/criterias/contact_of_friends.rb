class Score::Criterias::ContactOfFriends < Score::Criterias::Base
  include Score::Criterias::Shared::ContactOf
  include Score::Criterias::Shared::RunRawSql

  def self.ratio
    8
  end

  def calculate
    query = query_by_contact contact
    @vector_mkeys, mkeys = split_by_names(run_raw_sql(query)) { |mk| (mk.to_set & friends).to_a }
    mkeys.size
  end

  private

  def update_contact
    update_contact_vectors contact, @vector_mkeys, 'friends_with_contact'
  end

  def friends
    @friends ||= Contact::GetZazoFriends.new(contact).do.to_set
  end
end
