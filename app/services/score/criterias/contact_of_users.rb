class Score::Criterias::ContactOfUsers < Score::Criterias::Base
  include Score::Criterias::Shared::ContactOf
  include Score::Criterias::Shared::RunRawSql

  def self.ratio
    4
  end

  def calculate
    query = query_by_contact contact
    @vector_mkeys, mkeys = split_by_names(run_raw_sql(query)) { |mk| mk }
    mkeys.size
  end

  private

  def update_contact
    update_contact_vectors contact, @vector_mkeys, 'users_with_contact'
  end
end
