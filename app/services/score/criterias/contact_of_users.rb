class Score::Criterias::ContactOfUsers < Score::Criterias::Base
  def self.ratio
    3
  end

  def calculate
    run_raw_sql(query)[0]['total'].to_i
  end

  private

  def query
    <<-SQL
      WITH contact_values AS (
        SELECT
          DISTINCT value
        FROM contacts
          JOIN vectors ON contacts.id = vectors.contact_id
        WHERE contacts.id = #{contact.id}
      ) SELECT
          COUNT(DISTINCT contacts.id) total
        FROM contacts
          JOIN vectors ON contacts.id = vectors.contact_id
          JOIN contact_values ON contact_values.value = vectors.value
        WHERE contact_id != #{contact.id}
    SQL
  end
end
