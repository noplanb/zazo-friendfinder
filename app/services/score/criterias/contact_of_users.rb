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
    contact.vectors.each { |v| update_vector_with_additions v }
  end

  def update_vector_with_additions(vector)
    mkeys = @vector_mkeys[vector.name]
    unless mkeys.nil? || mkeys.empty?
      vector.additions ||= {}
      vector.additions['users_with_contact'] = mkeys
      vector.save
    end
  end
end
