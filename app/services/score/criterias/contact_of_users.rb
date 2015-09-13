class Score::Criterias::ContactOfUsers < Score::Criterias::Base
  def self.ratio
    4
  end

  def calculate
    mkeys = Set.new
    @vector_mkeys = run_raw_sql(query).each_with_object({}) do |row, memo|
      memo[row['name']] = row['mkeys'][1...-1].split(',')
      mkeys.merge memo[row['name']]
    end
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

  def query
    <<-SQL
      WITH contact_values AS (
        SELECT
          DISTINCT value
        FROM contacts
          JOIN vectors ON contacts.id = vectors.contact_id
        WHERE contacts.id = #{contact.id}
      ) SELECT
          name,
          array_agg(owner) mkeys
        FROM contacts
          JOIN vectors ON contacts.id = vectors.contact_id
          JOIN contact_values ON contact_values.value = vectors.value
        WHERE contact_id != #{contact.id}
        GROUP BY name
    SQL
  end
end
