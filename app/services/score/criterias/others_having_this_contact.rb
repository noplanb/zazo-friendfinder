class Score::Criterias::OthersHavingThisContact < Score::Criterias::Base
  def self.ratio
    3
  end

  def calculate
    run_raw_sql(query)[0].try(:[], 'total').to_i
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
      ), by_all_vectors AS (
        SELECT
          vectors.value,
          COUNT(DISTINCT contacts.id) count
        FROM contacts
          JOIN vectors ON contacts.id = vectors.contact_id
          JOIN contact_values ON contact_values.value = vectors.value
        WHERE contact_id != #{contact.id}
        GROUP BY vectors.value
      ) SELECT SUM(count) total FROM by_all_vectors
    SQL
  end
end
