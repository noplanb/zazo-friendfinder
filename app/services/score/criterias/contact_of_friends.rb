class Score::Criterias::ContactOfFriends < Score::Criterias::Base
  include Score::Criterias::Shared::ContactOf
  include Score::Criterias::Shared::RunRawSql

  def self.ratio
    8
  end

  def calculate
    query = query_by_contact contact
    @vector_mkeys, mkeys = split_by_names(run_raw_sql(query)) do |mk|
      (mk.to_set & friends).to_a
    end
    mkeys.size
  end

  private

  def friends
    @friends ||= Contact::GetZazoFriends.new(contact).do.to_set
  end
end
