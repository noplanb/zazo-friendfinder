class Score::Criterias::ContactOfUsers < Score::Criterias::Base
  include Score::Criterias::Shared::ContactOf
  include Score::Criterias::Shared::RunRawSql

  def self.ratio
    4
  end

  def calculate
    query = query_by_contact contact
    @distinct_mkeys = split_by_names(run_raw_sql(query)) { |mk| mk }
    @distinct_mkeys.size
  end

  private

  def update_contact
    update_contact_additions contact, 'users_with_contact', @distinct_mkeys.to_a
  end
end
