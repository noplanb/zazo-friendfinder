module Score::Criterias::Shared::ContactOf
  def split_by_names(results)
    distinct_mkeys = Set.new
    vector_mkeys = results.each_with_object({}) do |row, memo|
      mkeys_by_name = row['mkeys'][1...-1].split(',')
      memo[row['name']] = yield mkeys_by_name
      distinct_mkeys.merge memo[row['name']]
    end
    [vector_mkeys, distinct_mkeys]
  end

  def query_by_contact(contact)
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

  def update_contact_vectors(contact, vector_mkeys, addition_key)
    contact.vectors.each do |v|
      mkeys = vector_mkeys[v.name]
      unless mkeys.nil? || mkeys.empty?
        v.additions ||= {}
        v.additions[addition_key] = mkeys
        v.save
      end
    end
  end
end
