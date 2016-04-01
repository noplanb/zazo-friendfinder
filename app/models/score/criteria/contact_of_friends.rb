class Score::Criteria::ContactOfFriends < Score::Criteria::Base
  include Score::Criteria::Shared::ContactOf
  include Score::Criteria::Shared::RunRawSql

  def self.ratio
    8
  end

  def calculate
    query = query_by_contact contact
    @distinct_mkeys = split_by_names(run_raw_sql(query)) { |mk| (mk.to_set & friends).to_a }
    @distinct_mkeys.size
  end

  private

  def update_contact
    update_contact_additions contact, 'friends_with_contact', @distinct_mkeys.to_a
  end

  def friends
    @friends ||= contact.owner.fetch_data.friends.to_set
  end
end
